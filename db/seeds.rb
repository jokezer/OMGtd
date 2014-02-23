# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Type.create([{label:'inbox'}, {label:'next'}, {label:'scheduled'}, {label:'someday'},{label:'waiting'},
            {label:'completed'}, {label:'canceled'}])
user = User.create(email:'test@user.com', name:'Test User', password:'12345678', password_confirmation:'12345678')
user.todos.create([{title:'First todo', type_id:1}, {title:'Second todo', type_id:2}, {title:'Third todo', type_id:2},
             {title:'Forth todo', type_id:2},{title:'Fifth todo', type_id:3}])