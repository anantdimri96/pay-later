class Person
  attr_accessor :name
  attr_accessor :email

  def initialize(name, email = '')
    @name = name
    @email = email
  end

  def self.help_menu
    p 'new user u1 u1@email.in 1000    # new user with name, email, credit-limit'
    p 'new merchant m1 2%              # new merchant with name, discount-percentage'
    p 'new txn u1 m2 400               # new transaction with user, merchant, txn-amount'
    p 'update merchant m1 1%           # update merchant, new-discount-rate'
    p 'update user u1 200              # update user, credit-limit'
    p 'payback u1 300                  # Payback - user, payback-amount'
    p 'report dues u1'
    p 'report total-dues'
    p 'report users-at-credit-limit'
    p 'report discount m1    '
    p ' exit,q,quit                    # to quit'
  end
end

class User < Person
  attr_accessor :dues
  attr_accessor :credit_limit

  def initialize(name, email, credit_limit, dues = 0)
    @credit_limit = credit_limit
    @dues = dues
    super(name, email)
  end

  def self.check(user_list, key)
    user = user_list.select { |user| user.name == key }
    return true if user.empty?
    false
  end

  def transact(amt)
    if @credit_limit.to_i < @dues + amt
      p 'Rejected! (reason: credit limit)'
      false
    else
      @dues += amt
      p 'Successful transaction'
      true
    end
  end

  def payback(amt)
    @dues -= amt
    p " Payback Successful! (dues: #{@dues})"
  end

  def report_user_dues
    if dues < 0
      "Credit of #{dues.abs}"
    else
      dues
    end
  end

  def update_credit_limit(credit_limit)
    @credit_limit = credit_limit
    p 'credit_limit Updated!'
  end

  def self.users_at_credit_limit(user_list)
    if user_list.any?
      user_list.each do |user|
        if user.credit_limit.to_f == user.dues.to_f
          p "#{user.name} : #{user.dues} "
        end
      end
    else
      p 'No users are present! Please create a user and try again'
    end
  end
end

class Merchant < Person
  attr_accessor :discount_percentage
  attr_accessor :total_discount

  def initialize(name, discount_percentage)
    @discount_percentage = discount_percentage
    @total_discount = 0
    super(name)
  end

  def self.check(merchant, key)
    merchant = merchant.select { |merchant| merchant.name == key }
    return true if merchant.empty?
    false
  end

  def update_discount_percentage(discount_percentage)
    @discount_percentage = discount_percentage
  end

  def update_total_discount(amount)
    get_value = (@discount_percentage.to_f * amount).to_f / 100
    @total_discount += get_value
  end
end

user_list = []
merchant_list = []
loop do
  input = gets.chomp

  if input == 'exit' || input == 'q' || input == 'quit'
    p '========Exiting========'
    break
  elsif input == ''
    p 'enter key(return) is not a valid command. '
    p "\n"
    p "Use the following commands : \n"
    p "\n"
    Person.help_menu
    p "\n\n"

  else
    input = input.split(' ')
    if input[0] == 'new' && input[1] == 'user'
      user_status = User.check(user_list, input[2])
      if user_status
        u = User.new(input[2], input[3], input[4])
        user_list << u
        p u.name + "(#{u.credit_limit})"
      else
        p 'User found: Please user a unique name'
      end

    elsif input[0] == 'new' && input[1] == 'merchant'
      merchant_status = Merchant.check(merchant_list, input[2])
      if merchant_status
        m = Merchant.new(input[2], input[3])
        merchant_list << m
        p m.name + "(#{m.discount_percentage})"
      else
        p 'Merchant found: Please user a unique name'
      end

    elsif input[0] == 'new' && input[1] == 'txn'
      user = user_list.select { |user| user.name == input[2] }
      merchant = merchant_list.select { |merchant| merchant.name == input[3] }
      if user.first.nil? || merchant.first.nil?
        p "#{input[2]} : not found" if user.first.nil?
        p "#{input[3]} : not found" if merchant.first.nil?
      else
        check = user.first.transact(input[4].to_f)
        merchant.first.update_total_discount(input[4].to_f) if check
      end

    elsif input[0] == 'update' && input[1] == 'merchant'
      update_merchant = merchant_list.select { |merchant| merchant.name == input[2] }
      if update_merchant.first.nil?
        p "#{input[2]} : not found"
      else
        update_merchant.first.update_discount_percentage(input[3].to_f)
      end

    elsif input[0] == 'payback'
      payback_user = user_list.select { |user| user.name == input[1] }
      if payback_user.first.nil?
        p "#{input[1]} : not found"
      else
        payback_user.first.payback(input[2].to_f)
      end

    elsif input[0] == 'report' && input[1] == 'dues'
      user_dues = user_list.select { |user| user.name == input[2] }
      if user_dues.first.nil?
        p "#{input[2]} : not found"
      else
        p user_dues.first.report_user_dues
      end

    elsif input[0] == 'report' && input[1] == 'total-dues'
      total_dues = 0
      for user in user_list do
        total_dues += user.dues
        p "#{user.name} : #{user.dues}"
      end
      p "Total : #{total_dues}"

    elsif input[0] == 'report' && input[1] == 'users-at-credit-limit'
      User.users_at_credit_limit(user_list)

    elsif input[0] == 'update' && input[1] == 'user'
      update_user = user_list.select { |user| user.name == input[2] }
      if update_user.first.nil?
        p "#{input[2]} : not found"
      else
        update_user.first.update_credit_limit(input[3].to_f)
      end

    elsif input[0] == 'report' && input[1] == 'discount'
      discount_for_merchant = merchant_list.select { |merchant| merchant.name == input[2] }
      if discount_for_merchant.first.nil?
        p "#{input[2]} : not found"
      else
        p discount_for_merchant.first.total_discount
      end

    elsif input[0] == '-h'
      Person.help_menu
    else
      p "Not a Recognized Command :  use '-h' for command list"
    end
  end
end

