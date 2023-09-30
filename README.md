# README

STEPS TO RUN THE PROJECT  
STEP1 -  bundle install  
STEP2 -  yarn install  
STEP3 -  sudo systemctl start elasticsearch  
STEP4 -  rails db:setup  
STEP5 - create the user with your email from **rails console**   
        ``User.create(name: 'your name', email: 'your email, active: true, admin: true) ``  
STEP6 - rails s  

Start elasticsearch server before running the project  
