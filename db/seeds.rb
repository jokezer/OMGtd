# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.where(email: 'test@user.com', name: 'Test User', password: '12345678',
                  password_confirmation: '12345678').first_or_create!
user.todos.create([{title: 'First todo', status_id: 1},
                   {title: 'Second todo', status_id: 2},
                   {title: 'Third todo', status_id: 2},
                   {title: 'Forth todo', status_id: 2},
                   {title: 'Fifth todo', status_id: 2}])