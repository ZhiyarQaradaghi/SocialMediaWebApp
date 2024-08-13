const express = require('express')
const app = express()
const path = require('path')
const port = 8080
const sqlite3 = require('sqlite3').verbose();  
var cors = require('cors')

const db = new sqlite3.Database('database.db');
app.use(express.json())
app.use(cors())



app.post('/article', (req, res) => {
    const {name, content} = req.body;
    const date = Date.now();
    db.run(
        `
            INSERT INTO posts 
            (
                name,
                content,
                date
            )
            VALUES
            (
                ?,
                ?,
                ?
                )
        `, [name, content, date], () => { res.send('Done! the values are inserted to database') }
    )
    
})


app.get('/article', (req, res) => {
    db.all( 
        `
            SELECT * FROM posts
        `, (error, rows) => { 
            if(error) {
                console.error('Error getting http request from server', error);
                res.status(500).send('Server error - Internal')
            } else {
                console.log(rows)
                res.json(rows)
            }
         }
    )
    
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})
