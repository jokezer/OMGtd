# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(email: 'test@user.com', name: 'Test User', password: '12345678',
                  password_confirmation: '12345678')
user = User.find_by_email('test@user.com')
user.todos.create([{title: 'First todo'},
                   {title: 'Second todo'},
                   {title: 'Third todo', kind:'next'},
                   {title: 'Forth todo', kind:'next'},
                   {title: 'Fifth todo', kind:'waiting'}])
user.projects.create(title:'Test project', content:'content of test project')