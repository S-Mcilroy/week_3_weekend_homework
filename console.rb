require('pry')
require_relative("models/customer.rb")
require_relative("models/film.rb")
require_relative("models/ticket.rb")
require_relative("models/screening.rb")

Ticket.delete_all
Screening.delete_all
Film.delete_all
Customer.delete_all

customer1 = Customer.new(
  {
    "name" => "Steven",
    "funds" => 100
  }
)

customer2 = Customer.new(
  {
    "name" => "Ian",
    "funds" => 150
  }
)

customer3 = Customer.new(
  {
    "name" => "Emma",
    "funds" => 200
  }
)

customer1.save
customer2.save
customer3.save

film1 = Film.new(
  {
    "title" => "Avengers",
    "price" => 75
  }
)

film2 = Film.new(
  {
    "title" => "Iron Man",
    "price" => 50
  }
)

film3 = Film.new(
  {
    "title" => "Thor",
    "price" => 25
  }
)

film1.save
film2.save
film3.save

screening1 = Screening.new(
  {
    "start_time" => "08:00",
    "tickets_limit" => 4
  }
)

screening2 = Screening.new(
  {
    "start_time" => "12:00",
    "tickets_limit" => 3
  }
)

screening3 = Screening.new(
  {
    "start_time" => "15:00",
    "tickets_limit" => 5
  }
)

screening4 = Screening.new(
  {
    "start_time" => "10:00",
    "tickets_limit" => 3
  }
)

screening5 = Screening.new(
  {
    "start_time" => "17:00",
    "tickets_limit" => 3
  }
)

screening6 = Screening.new(
  {
    "start_time" => "20:00",
    "tickets_limit" => 3
  }
)

screening1.save
screening2.save
screening3.save
screening4.save
screening5.save


ticket1 = Ticket.new(
  {
    "customer_id" => customer1.id,
    "film_id" => film2.id,
    "screening_id" => screening2.id
  }
)

ticket2 = Ticket.new(
  {
    "customer_id" => customer1.id,
    "film_id" => film3.id,
    "screening_id" => screening4.id
  }
)

ticket3 = Ticket.new(
  {
    "customer_id" => customer2.id,
    "film_id" => film1.id,
    "screening_id" => screening1.id
  }
)

ticket4 = Ticket.new(
  {
    "customer_id" => customer2.id,
    "film_id" => film2.id,
    "screening_id" => screening2.id
  }
)

ticket5 = Ticket.new(
  {
    "customer_id" => customer2.id,
    "film_id" => film3.id,
    "screening_id" => screening3.id
  }
)

ticket6 = Ticket.new(
  {
    "customer_id" => customer3.id,
    "film_id" => film1.id,
    "screening_id" => screening1.id
  }
)

ticket7 = Ticket.new(
  {
    "customer_id" => customer3.id,
    "film_id" => film3.id,
    "screening_id" => screening3.id
  }
)

ticket1.save
ticket2.save
ticket3.save
ticket4.save
ticket5.save
ticket6.save
ticket7.save



binding.pry
nil
