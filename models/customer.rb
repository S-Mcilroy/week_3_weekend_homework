require_relative("../db/sql_runner.rb")

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @name = options["name"]
    @funds = options["funds"].to_i
  end

  def self.all
    sql = "SELECT * FROM customers"
    result = SqlRunner.run(sql)
    return result.map{|customer| Customer.new(customer)}
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def save()
    sql = "INSERT INTO customers (name, funds)
           VALUES ($1, $2) RETURNING id"
    values = [@name, @funds]
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE customers SET (name, fund) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  # Show which films a customer has booked to see
  def films()
    sql = "SELECT films.* FROM films INNER JOIN tickets
    ON films.id = tickets.film_id WHERE tickets.customer_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.map{|film| Film.new(film)} if result.any?
    return nil
  end


  def tickets
    sql = "SELECT tickets.* FROM tickets WHERE tickets.customer_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.map{|ticket| Ticket.new(ticket)} if result.any?
    return nil
  end

  # Check how many tickets were bought by a customer
  def self.tickets_by_id(id)
    sql = "SELECT tickets.* FROM tickets WHERE tickets.customer_id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    return result.map{|ticket| Ticket.new(ticket)} if result.any?
    return nil
  end

  # Buying tickets should decrease the funds of the customer by the price
  def remaining_funds()
     fees = 0
     sql = "SELECT films.price FROM films INNER JOIN tickets
     ON tickets.film_id = films.id WHERE tickets.customer_id = $1"
     values = [@id]
     results = SqlRunner.run(sql, values)
     for charge in results
       fees += charge["price"].to_i
     end
     return @funds - fees
   end


end
