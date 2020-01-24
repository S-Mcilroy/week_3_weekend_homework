require_relative("../db/sql_runner.rb")


class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @title = options["title"]
    @price = options["price"].to_i
  end

  def self.all
    sql = "SELECT * FROM films"
    result = SqlRunner.run(sql)
    return result.map{|film| Film.new(film)}
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def save()
    sql = "INSERT INTO films (title, price)
           VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

# see which customers are coming to see one film.
  def customers()
    sql = "SELECT customers.* FROM customers INNER JOIN tickets
    ON customers.id = tickets.customer_id WHERE tickets.film_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.map{|customer| Customer.new(customer)} if result.any?
    return nil
  end

  # Check how many customers are going to watch a certain film
  def self.customers_by_id(id)
    sql = "SELECT customers.* FROM customers INNER JOIN tickets
    ON customers.id = tickets.customer_id WHERE tickets.film_id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    return result.map{|ticket| Ticket.new(ticket)} if result.any?
    return nil
  end

  def find_popular_time
    sql = "SELECT screenings.start_time FROM screenings INNER JOIN tickets
    ON tickets.screening_id = screenings.id WHERE tickets.film_id = $1
    GROUP BY screenings.start_time
    ORDER BY COUNT(*) DESC"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result[0]["start_time"]
  end

end
