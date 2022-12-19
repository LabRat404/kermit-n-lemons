const express = require('express');
const User = require("../models/user");
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
        const {name, email, password} = req.body;
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

module.exports = authRouter; //allow public access