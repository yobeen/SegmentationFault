# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(name: 'Morrison')
User.create(name: 'Hektor')
User.create(name: 'Jordan')
User.create(name: 'Camarines')
User.create(name: 'Reptile')

Question.create(title: 'Is there life on Mars?', 
  content: 'Mars is the fourth planet from the Sun and the second smallest planet in the Solar System, after Mercury.\
Named after the Roman god of war, it is often referred to as the \"Red Planet\" because the iron oxide\
 prevalent on its surface gives it a reddish appearance.', user: User.first)
 
Question.create(title: 'Understand Rails Authenticity Token', content: 'I am running into some issues regarding\
 Authenticity Token in rails, as I did many times now.\
 Well, my question is, do you have some complete source of information\
    on this subject or would spend your time to explain in details here?', user: User.first )
                                                 
Question.create(title: 'How can I rename a database column in a Rails migration??', 
  content: 'I wrongly named a column hased_password instead of hashed_password. \
  How can I use a migration to rename this column?', user: User.second)

Answer.create(content: 'I have only \"multiple\" in select options. I think it\'s something wrong with my form.', 
                                                     question: Question.first, user: User.all[3])
                                                     
                                                     
Answer.create(content: 'This will also automatically have the model\'s selected categories populate the\
                                                       select field as highlighted when on an edit form.', 
                                                     question: Question.first, user: User.all[4] )
