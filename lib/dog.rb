class Dog
    attr_accessor :id, :name, :breed
    
    def initialize(id: nil, name:, breed:)
        @id = id
        @name = name
        @breed = breed
    end

    def self.create_table
        sql = <<-SQL
        CREATE TABLE IF NOT EXISTS dogs (
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed Text
            )
            SQL
            DB[:conn].execute(sql)
    end

    def self.drop_table
        sql = <<-SQL
          DROP TABLE IF EXISTS dogs
        SQL
        DB[:conn].execute(sql)
    end

    def save
        sql = <<-SQL
          INSERT INTO dogs (name, breed)
          VALUES (?, ?)
        SQL
    
        DB[:conn].execute(sql, self.name, self.breed)
    
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    
        self
      end
   
    def self.create(attributes)
        dog = self.new(attributes)
        dog.save
        dog 
    end   

    def self.new_from_db(row)
        new_dog = self.new(id: row[0], name: row[1], breed: row[2])
        new_dog
    end

    def self.all
        sql = "SELECT * FROM dogs"
        results = DB[:conn].execute(sql)
        results.map { |row| self.new_from_db(row) }
    end

    def self.find_by_name(name)
        sql = "SELECT * FROM dogs WHERE name = ? LIMIT 1;"
        row = DB[:conn].execute(sql, name).first
        self.new_from_db(row)
    end

    def self.find(id)
        sql = "SELECT * FROM dogs WHERE id = ?"
        result = DB[:conn].execute(sql, id).first
        self.new(id: result[0], name: result[1], breed: result[2])
    end

    def self.find_or_create_by(name:, breed:)
        sql = "SELECT * FROM dogs WHERE name = ? AND breed = ?"
        result = DB[:conn].execute(sql, name, breed)
    
        if !result.empty?
          dog_data = result[0]
          dog = Dog.new_from_db(dog_data)
        else
          dog = Dog.create(name: name, breed: breed)
        end
        dog
      end
    
      def update
        sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
        DB[:conn].execute(sql, self.name, self.breed, self.id)
      end
end
      

  
    
    
    
    
    
    
    


