require_relative("../db/sql_runner.rb")

class Screening

  attr_reader :id
  attr_accessor :start_time, :tickets_limit

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @start_time = options["start_time"]
    @tickets_limit = options["tickets_limit"].to_i
  end

  def self.all
    sql = "SELECT * FROM screenings"
    result = SqlRunner.run(sql)
    return result.map{|screening| Screening.new(screening)}
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def save()
    sql = "INSERT INTO screenings (start_time, tickets_limit)
           VALUES ($1, $2) RETURNING id"
    values = [@start_time, @tickets_limit]
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i
  end

  def delete()
    sql = "DELETE FROM screenigns WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE screenings SET (start_time, tickets_limit) = ($1, $2) WHERE id = $3"
    values = [@start_time, @tickets_limit, @id]
    SqlRunner.run(sql, values)
  end

  def remaining_tickets()
     taken_seats = 0
     sql = "SELECT COUNT(screening_id) FROM tickets WHERE tickets.screening_id =$1"
     values = [@id]
     results = SqlRunner.run(sql, values)
     taken_seats += results[0]["count"].to_i
     return @tickets_limit - taken_seats
   end

   def attending_customers()
     sql = "SELECT customers.* FROM customers INNER JOIN tickets
     ON customers.id = tickets.customer_id WHERE tickets.screening_id = $1"
     values = [@id]
     result = SqlRunner.run(sql, values)
     return result.map{|customers| Customer.new(customers)} if result.any?
     return nil
   end


end
