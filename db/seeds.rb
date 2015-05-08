# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Admin.create(email: 'cool@gmail.com', password: 'foobar', password_confirmation: 'foobar')

makes = %w( Audi Volkswagen Honda Toyota Jeep )

audi = %w( A3 A5 A6 TT Q5 )

volkswagen = %w( Quattro Beatle Jetta Golf Passat)

honda = %w( Civic Accord CR-V Odyssey Passport )

toyota = %w( Corolla Camry RAV4 Prius Sienna )

jeep = %w( Wrangler Cherokee Patriot Compass Commander )

models = [audi, volkswagen, honda, toyota, jeep]

engines = %w( 1.2l 2.2l 3.8l V6 V8 )

5.times do |n|
  make = Make.create(make: makes[n])
  5.times do |t|
    make.models << Model.create(model: models[n][t])
  end
  make.models.each do |model|
    engines.each do |engine|
      model.engines << Engine.create(engine: engine)
    end
    model.engines.each do |engine|
      engine.years << Year.create(years: [1989, 2003])
      engine.years << Year.create(years: [2005, 2012])
    end
  end
end

# Year.all.each do |y|
#   y.init_vehicle
# end
