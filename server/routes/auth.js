const express = require('express');
const authRouter = express.Router();
const User = require('../models/user');
const jwt = require('jsonwebtoken');
const auth =require('../middleware/auth_middleware');

authRouter.post('/api/signup',async (req,res)=>{
    try{
        const {name,email,photoUrl}=req.body;
        let user = await User.findOne({ email });
        if (!user) {

            let user = new User({
                name,email,photoUrl
            });
            user = await user.save();
        }
        const token = jwt.sign({id:user._id},"passwordKey");
        res.json({user,token});
    }
    catch(e){
        res.status(500).json({error :e.message});

    }
});
authRouter.get('/',auth,async (req,res)=>{
    try{
        const user = await User.findById(req.user);
        res.json({user,token:req.token});

    }
    catch(e){
        res.status(500).json({error :e.message});
    }
});

module.exports=authRouter;
