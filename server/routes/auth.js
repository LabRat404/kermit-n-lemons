const express = require('express');
const User = require("../models/user");
const Image2 = require("../models/uploadImage");
const Chatters = require("../models/chatters");
const isbn = require('node-isbn');
const bcryptjs = require('bcryptjs');
const jwt = require("jsonwebtoken");
const authRouter = express.Router();

authRouter.get("/test", (req, res) => {
    res.json({
        test: "this is the testing api"
    });
});

authRouter.post("/api/bookinfo", async (req, res) => {
    const { book_isbn } = req.body;

    isbn.resolve(book_isbn).then(function (book) {
        return res.json(book);
    }).catch(function (err) {
        res.status(401).json({ error: err });
    });
});

authRouter.post("/api/signin", async(req, res) => {
    try {
        const {email, password} = req.body;
        const user = await User.findOne( {email} );
        if (!user) {
            return res.status(400).json({
                msg: "No user found!"
            });
        }
        const isMatch = await bcryptjs.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json( {
                msg: "incorrect password!"
            });
        }

        const token = jwt.sign({id: user._id}, "passwordKey"); //private key
        res.json({token, ...user._doc});
        // {
        //     'token': 'abcd'
        //     'name': 'doria',
        //     'email': 'admin123@gmail.com'
        // }
    } catch (e) {
        res.status(500).json( {
                error: e.message
            }
        );
    }
});


authRouter.post("/api/signup", async (req, res) => {
    try {
        const {name, email, password, address} = req.body;
        // {
        //     'name':name,
        //     'email':email,
        //     'password':password
        // }
        
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res
                .status(400)
                .json({ msg: 'User with same email already exists!' });
        }
        const hashedPassword = await bcryptjs.hash(password, 8);

        let user = new User({ //save to MongoDB
            email,
            password: hashedPassword,
            name,
            address,
        })
        user = await user.save();
        res.json(user);

        // 200 OK
        // get the data from client, 
        // post that data in db
        // return that data to the user
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

authRouter.post("/api/uploading", async (req, res) => {
    try {
  
            Image2.create({
            name: req.body['name'],
            url: req.body['url'],
            delhash: req.body['delhash'],
            dbISBN: req.body['dbISBN'],
            comments: req.body['comments'],
            username: req.body['username'],
            booktitle: req.body['booktitle'],
            author: req.body['author'],
            googlelink: req.body['googlelink']
            
          }, (e, results) => {
            if (e)
              res.send(e);
            else
              res.send("Ref: asdasdsd");
          });
        // get the data from client, 
        // post that data in db
        // return that data to the user
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

authRouter.get("/api/grabuserlist/:username", async (req, res) => {
    console.log(req.params["username"]);
    Image2
    .find({username : req.params["username"]})
    .exec( (e, results) => {
        if (e)
          res.send("Error not known");
      else if(results == null)
          res.send("404 not found. No records found!", 404);
        else{
        res.send(results);
        }
     }
     );   
});

authRouter.get("/api/grabdbbook/:hashname", async (req, res) => {
    console.log(req.params["hashname"]);
    Image2
    .find({name : req.params["hashname"]})
    .exec( (e, results) => {
        if (e)
          res.send("Error not known");
      else if(results == null)
          res.send("404 not found. No records found!", 404);
        else{
        res.send(results);
        }
     }
     );   
});

authRouter.get("/api/graballuserbook", async (req, res) => {
   
    Image2
    .find().sort( { booktitle: 1 } )
    .exec( (e, results) => {
        if (e)
          res.send("Error not known");
      else if(results == null)
          res.send("404 not found. No records found!", 404);
        else{
        res.send(results);
        }
     }
     );   
});

authRouter.get("/api/grabuserdata/:username", async (req, res) => {
    console.log(req.params["username"]);
    User
    .findOne({name : req.params["username"]})
    .exec( (e, results) => {
        if (e)
          res.send("Error not known");
      else if(results == null)
          res.send("404 not found. No records found!", 404);
        else{
        res.send(results);
        //console.log(results);
        }
     }
     );

});


authRouter.put("/api/changeavatar/:username", async (req, res) => {
    console.log(req.params["username"]+ req.body['url']);
  
    User
    .findOne({name : req.params["username"]})
    .exec((e, results) => {
        if (e)
          res.send("Error not known");
      else if(results == null)
          res.send("404 not found. No records found!", 404);
        else{
        results.address = req.body['url'];
        results.save();
        res.send(results);

        //console.log(results  + "ASdasdsadasdsad test" + req.body['url']);
        }
     }
     );

});

authRouter.delete("/api/dellist/:dellist", async (req, res) => {
    console.log("sadad");
    Image2
    .find({name : req.params["dellist"]})
    .deleteOne()
    .exec( (e, results) => {
        if (e)
          res.send("Error not known");
      else if(results == null)
          res.send("404 not found. No records found!", 404);
        else{
          
        res.send(results);
        }
     }
     );
});

//not yet done
authRouter.delete("/api/deluser/:username", async (req, res) => {
    console.log(req.params["username"]);
    Image2
    .find({username : req.params["username"]})
    .exec( (e, results) => {
        if (e)
          res.send("Error not known");
      else if(results == null)
          res.send("404 not found. No records found!", 404);
        else{
        res.send(results);
        }
     }
     );
});

authRouter.get("/api/grabchat/:username", async (req, res) => {
    console.log(req.params["username"]);
    Chatters
    .find({$or: [
        {
          self: req.params["username"]
        },
        {
          notself: req.params["username"]
        }
      ]})
    .exec( (e, results) => {
        if (e)
          res.send("Error not known");
      else if(results == null)
          res.send("Empty");
        else{
        res.send(results);
        }
     }
     );   
});


authRouter.post("/api/createnloadChat", async (req, res) => {
    try {
   
        //  };
       
        // print("asdsad");
        console.log(req.body["self"] + req.body["notself"] + req.body["msg"]+  new Date() + req.body["randomhash"]);
        Chatters
        .find({$or: [
            {
              self: req.body["self"],
              notself: req.body["notself"]
            },
            {
              self: req.body["notself"],
              notself: req.body["self"]
            }
          ]})
          .exec( (e, results) => {
            if (e)
              res.send("Error not known");
          else if(results.length ==0){
            // console.log(results + "hi1");
            Chatters
            .create({
                self: req.body['self'],
                notself: req.body['notself'],
                randomhash: req.body["randomhash"],
                chatter: [{dates: new Date().toString}, {user: req.body["self"],text: req.body["msg"]}]
                //{dates: new Date()}, {user: req.body["self"],text: msg}
              })
            
          } 
            else{
                console.log("already have");
           
            }
         }
         ); 


        
        // get the data from client, 
        // post that data in db
        // return that data to the user
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});
//Chatters

module.exports = authRouter; //allow public access