require 'sqlite3'

class ReleaseDatabase
  attr_reader :db

  def initialize(dbname = "releases")
    @db = SQLite3::Database.new "database/#{dbname}.db"

  end

  def reset_schema!

    # label_code BLOB,artist TEXT,title TEXT,label TEXT,format TEXT,released INTEGER,date_added TEXT
    # one table
    query = <<-CREATESTATEMENT
      CREATE TABLE albums (
        id INTEGER PRIMARY KEY,
        label_code BLOB,
        artist TEXT NOT NULL,
        title TEXT NOT NULL,
        label TEXT,
        format TEXT,
        released INTEGER,
        date_added TEXT
        );
      CREATESTATEMENT
      # runs ONLY one query
      @db.execute("DROP TABLE IF EXISTS albums;")
      @db.execute(query)
  end
end

release_db = ReleaseDatabase.new
release_db.reset_schema!