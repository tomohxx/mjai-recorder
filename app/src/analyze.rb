#!/usr/local/bin/ruby
require "pg"
require "json"

class Analyzer
  def initialize(connection, file_name)
    @connection = connection
    @file_name = file_name
    @game_id = nil
    @kyoku_id = nil
    @player_id = Array.new(4)
  end

  def insert_game()
    file_name = File.basename(@file_name, ".mjson")
    @connection.exec("INSERT INTO game(file_name) VALUES ('#{file_name}')")
    result = @connection.exec("SELECT LASTVAL() FROM game")
    @game_id = result[0]["lastval"]
  end

  def update_game()
    @connection.exec("UPDATE game SET error_flag = TRUE WHERE id = #{@game_id}")
  end

  def insert_player(seat, name)
    @connection.exec("INSERT INTO player(player_name) SELECT '#{name}' WHERE NOT EXISTS (SELECT player_name FROM player WHERE player_name = '#{name}')")
    result = @connection.exec("SELECT id FROM player WHERE player_name = '#{name}'")
    @player_id[seat] = result[0]["id"]
    @connection.exec("INSERT INTO game_player(game_id,player_id,seat) VALUES (#{@game_id},#{@player_id[seat]},#{seat})")
  end

  def update_player(seat, score, position)
    @connection.exec("UPDATE game_player SET score = #{score}, position = #{position} WHERE game_id = #{@game_id} AND player_id = #{@player_id[seat]}")
  end

  def insert_kyoku(bakaze, kyoku, honba)
    @connection.exec("INSERT INTO kyoku(game_id,bakaze,kyoku,honba) VALUES (#{@game_id},'#{bakaze}',#{kyoku},#{honba})")
    result = @connection.exec("SELECT LASTVAL()")
    @kyoku_id = result[0]["lastval"]
  end

  def insert_riichi(actor)
    @connection.exec("INSERT INTO riichi(player_id,kyoku_id) VALUES (#{@player_id[actor]},#{@kyoku_id})")
  end

  def insert_naki(actor, target, naki_type)
    @connection.exec("INSERT INTO naki(actor_id,target_id,kyoku_id,naki_type) VALUES (#{@player_id[actor]},#{@player_id[target]},#{@kyoku_id},'#{naki_type}')")
  end

  def insert_winning(actor, target, delta)
    @connection.exec("INSERT INTO hora(actor_id,target_id,delta,kyoku_id) VALUES (#{@player_id[actor]},#{@player_id[target]},#{delta},#{@kyoku_id})")
  end

  def insert_ryukyoku(actor, tenpai)
    @connection.exec("INSERT INTO ryukyoku(player_id,tenpai,kyoku_id) VALUES (#{@player_id[actor]},#{tenpai},#{@kyoku_id})")
  end

  def start_game(message)
    insert_game()

    message["names"].each_with_index do |name, index|
      insert_player(index, name)
    end
  end

  def start_kyoku(message)
    insert_kyoku(message["bakaze"], message["kyoku"], message["honba"])
  end

  def reach(message)
    insert_riichi(message["actor"])
  end

  def pon(message)
    insert_naki(message["actor"], message["target"], "pon")
  end

  def chi(message)
    insert_naki(message["actor"], message["target"], "chi")
  end

  def daiminkan(message)
    insert_naki(message["actor"], message["target"], "daiminkan")
  end

  def hora(message)
    insert_winning(message["actor"], message["target"], message["deltas"][message["actor"]])
  end

  def ryukyoku(message)
    4.times do |i|
      insert_ryukyoku(i, message["tenpais"][i])
    end
  end

  def end_game(message)
    scores = message["scores"]
    i = 0
    seats = [*0..3].sort_by{|v| [-scores[v], i+=1]}

    4.times do |i|
      update_player(seats[i], scores[seats[i]], i+1)
    end
  end

  def execute()
    File.open(@file_name) do |file|
      lines = file.readlines

      for line in lines
        message = JSON.parse(line)
    
        begin
          self.send("#{message['type']}", message)
        rescue NoMethodError
        end
      end

      if message["type"] != "end_game"
        update_game()
      end
    end
  end
end

connection = PG::connect(host: "db", user: "user", password: "password", dbname: "mjai_db")
file_name = Dir.glob("/log_dir/*.mjson").max_by{|f| File.mtime(f)}
analyzer = Analyzer.new(connection, file_name)
analyzer.execute()
