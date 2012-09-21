Dogs = new Meteor.Collection("dogs")
Persons = new Meteor.Collection("persons")
Kennels = new Meteor.Collection("kennels")
  

#function that only lets admins do stuff
require_admin = (userId, docs) ->
  u = Meteor.users.findOne({_id:userId})
  console.log u
  if u.role is "admin"
    true
  else
    false

#setting permissions on the dogs collection so that only admin can remove
Dogs.allow {
  remove: 
    (userId,docs) ->
      require_admin(userId,docs)
      
  #everybody can insert
  insert: 
    () -> true
  }

#setting Kennels permissions
Kennels.allow {
  remove:
    (userId,docs) -> 
      require_admin(userId,docs)
  #everybody can insert
  insert: 
    () -> true
  }

#creating admin user (server only - sends an email to activate). This should be called only once when deploying an app
#to setup initial admin user
create_admin = ->
  if Meteor.users.find({username: "admin"}).count() is 0
    aid = Meteor.createUser({username: "admin", email: "aantich@gmail.com"},{role:"admin"})
    


#prepopulating stuff
reset_data = ->
  Dogs.remove {}
  Persons.remove {}
  Kennels.remove {}
  Meteor.users.remove {}
  kennels_tmp = [
    ["Солнце Балтии", "Solntse Baltii", "Наталья Чижова", "Санкт-Петербург", "http://www.solntsebaltii2007.narod.ru/"],
    ["Старз Мериленд", "Starz Merilend", "Мария Лунникова", "Санкт-Петербург", "http://starzmerilend.ru"],
    ["Стенвэйз", "Stenveyz",  "Татьяна Димитриу",  "Москва", "http://stenways.retriever.ru"],
    ["Вандер Вэлли",  "Wonder Valley", "Екатерина Дементьева",  "Москва","#"], 
    ["Валнериз",  "Valneriz",  "Анна Лебедева", "Москва","#"], 
    ["Эвалайз", "Evalaiz", "Юлия Родзивон", "Рыбинск","#"], 
    ["Берсифьёр", "Bersifjor", "Светлана Беликова", "Москва-Краснодар","#"],
    ["Колкуд Хаус", "Kolkud Haus", "Вера Колышенко",  "Москва","#"],
    ["Малет Парк",  "Maler Park",  "Елена Иванова", "Великий Новгород", "http://maletpark.com"],
    ["Луссо Анжело",  "Lusso Angelo",  "Татьяна Хоруженко", "Волгоград", "http://lussoangelo.ru"],
    ["Радость Из Истры",  "Radost' Iz Istry",  "Лидия и Георгий Бараусовы", "Москва","http://istra.retriever.ru"],
    ["Саншани Стар",  "Sunshine Star", "Елена Пернак",  "Владивосток", "http://sunshinestar.ru/lucky/luckychild.htm"],
    ["Таллиар Шикари",  "Talliar Shikary", "Марина Кораблева",  "Магнитогорск", "http://www.talliar-shikary.ru/"],
    ["Вэнари Лэнд", "Vanary Land", "Ульяна Суродеева",  "Пермь","#"] 
  ]
  

  dogs_tmp = [["Meeka", "brown", "21/12/2002"], ["Uta", "black", "30/10/2004"], ["Toma", "brown", "21/08/2007"]]

  for dg in dogs_tmp
  
    Dogs.insert
      name: dg[0]
      color: dg[1]
      date: dg[2]
    
  for kn in kennels_tmp
    Kennels.insert
      ru_name: kn[0]
      name: kn[1]
      owner: kn[2]
      city: kn[3]
      url: kn[4]

Meteor.startup ->
  console.log("Firing up")
  TelescopeLogger.log ("Firing up in TelescopeLogger")
  reset_data()  if Dogs.find().count() is 0
  create_admin()