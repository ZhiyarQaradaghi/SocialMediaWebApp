const sqlite3 = require('sqlite3')
db = new sqlite3.Database('database.db')

db.run(
    `
        CREATE TABLE IF NOT EXISTS posts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name NVARCHAR(255),
            content NVARCHAR(255),
            date INTEGER
        )    
    `
);

