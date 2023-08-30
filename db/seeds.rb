# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#   rubocop:disable all

User.create(name: 'Azad Singh', email: 'azads5275@gmail.com', active: true, admin: true)

# Create Brands
brand1 = Brand.create(name: 'Hp')
brand2 = Brand.create(name: 'Lenovo')
brand3 = Brand.create(name: 'Dell')
brand4 = Brand.create(name: 'Apple')
brand5 = Brand.create(name: 'Asus')
brand6 = Brand.create(name: 'Acer')

# Create Categories
category1 = Category.create(name: 'Laptop', required_quantity: 10, buffer_quantity: 1, priority: 'high')
category2 = Category.create(name: 'Mouse', required_quantity: 8, buffer_quantity: 1, priority: 'medium')
category3 = Category.create(name: 'Keyboard', required_quantity: 5, buffer_quantity: 1, priority: 'low')
category4 = Category.create(name: 'Monitor', required_quantity: 3, buffer_quantity: 1, priority: 'high')

# Create Users
user1 = User.create(name: 'User_1', email: 'user1@example.com', active: true, admin: true)
user2 = User.create(name: 'User_2', email: 'user2@example.com', active: true, admin: false)
user3 = User.create(name: 'User_3', email: 'user3@example.com', active: true, admin: false)
user4 = User.create(name: 'User_4', email: 'user4@example.com', active: true, admin: false)

# Create Items
item1 = Item.create(uid: '52', name: 'Item 1', status: true, brand: brand1, category: category1, user: nil)
item2 = Item.create(uid: '7292', name: 'Item 2', status: false, brand: brand2, category: category2, user: user2)
item3 = Item.create(uid: '1234', name: 'Item 3', status: true, brand: brand3, category: category3, user: nil)
item4 = Item.create(uid: '578', name: 'Item 4', status: false, brand: brand3, category: category2, user: nil)
item5 = Item.create(uid: '568', name: 'Item 5', status: true, brand: brand4, category: category1, user: user4)
item6 = Item.create(uid: '567', name: 'Item 6', status: false, brand: brand5, category: category4, user: user4)
item7 = Item.create(uid: '5697', name: 'Item 7', status: true, brand: brand6, category: category3, user: user3)
item8 = Item.create(uid: '5627', name: 'Item 8', status: false, brand: brand6, category: category4, user: nil)
# Create Issues
issue1 = Issue.create(id: '1207', description: 'it is not working ', status: false, user: user2, item: item1)
issue2 = Issue.create(id: '1107', description: 'buttons ar not working', status: false, user: user2, item: item2)
issue3 = Issue.create(id: '1307', description: 'Issue_3', status: false, user: user3, item: item3)
issue4 = Issue.create(id: '1267', description: 'Issue_4', status: false, user: user4, item: item4)
issue5 = Issue.create(id: '1457', description: 'Issue_5', status: false, user: user4, item: item5)
