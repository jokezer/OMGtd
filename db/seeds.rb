# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.create(email:'test@user.com', name:'Test User', password:'12345678', password_confirmation:'12345678')
user.todos.create([{title:'First todo', status: 'inbox'}, {title:'Second todo', status: 'inbox'}, {title:'Third todo', status: 'next'},
             {title:'Forth todo', status: 'someday'},{title:'Fifth todo', status: 'canceled'}])