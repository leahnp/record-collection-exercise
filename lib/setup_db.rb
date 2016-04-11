require 'sqlite3'
require 'csv'

class ReleaseDatabase
  FILE = 'source/20160406-record-collection.csv'
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

  def load!
    insert_statement = <<-INSERSTATEMENT
      INSERT INTO albums (
        label_code, artist, title, label, format, released, date_added
      ) VALUES (
        :label_code, :artist, :title, :label, :format, :released, :date_added
      );
    INSERSTATEMENT

    # prepare the insert statement
    prepared_statement = @db.prepare(insert_statement)

    # now that we have a prepared statement, we can iterate the CSV and use its values to populate our database
    CSV.foreach(FILE, headers: true) do |row|
      prepared_statement.execute(row.to_h)
    end

  end
end

release_db = ReleaseDatabase.new
release_db.reset_schema!
release_db.load!