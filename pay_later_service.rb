    class Person
      attr_accessor :name
      
      def initialize(name,email="")
      @name, @email = name,email
      end

      def self.help_menu
        p "new user u1 u1@email.in 1000    # new user with name, email, credit-limit"
        p "new merchant m1 2%              # new merchant with name, discount-percentage"
        p "new txn u1 m2 400               # new transaction with user, merchant, txn-amount"
        p "update merchant m1 1%           # update merchant, new-discount-rate"
        p "payback u1 300                  # Payback - user, payback-amount"
        p "report dues u1"
        p "report total-dues"
        p "report users-at-credit-limit"
        p "report discount m1    "
        p " exit,q,quit                   # to quit"
      end
      
    end

    class User < Person
      
      attr_accessor :dues
      attr_accessor :credit_limit

      def initialize(name, email, credit_limit,dues=0)
        @credit_limit, @dues = credit_limit, dues
        super(name, email)
      end

      def transact(amt)
        if @credit_limit.to_i < @dues + amt
          p "Rejected! (reason: credit limit)"
          return false
        else
          @dues+=amt
          p "Successful transaction"
          return true
        end
      end

      def payback(amt)
        @dues-=amt
        p " Payback Successful! (dues: #{@dues})"

      end

      def report_user_dues
          if self.dues < 0
            return "Credit of #{self.dues.abs}" 
          else 
            return self.dues
                    
          end        
      end

      def update_credit_limit(credit_limit)
       @credit_limit = credit_limit
        puts "credit_limit Updated!"
      end

      def self.users_at_credit_limit(user_list)
        if user_list.any?
          user_list.each do |user|
            if  user.credit_limit.to_f == user.dues.to_f
             p "#{user.name} : #{user.dues} "
            end
          end
        else 
        puts "No users are present! Please create a user and try again"  
          
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
  
      def update_discount_percentage(discount_percentage)
        @discount_percentage = discount_percentage
      end

      def update_total_discount(amount)
        get_value=(@discount_percentage.to_f*amount).to_f/100
        @total_discount+=get_value        
      end
    end


    user_list = []
    merchant_list = []
    while(1)
      input = gets.chomp

      if(input == "exit" || input == "q" || input=="quit")
        puts "========Exiting========"
        break
      elsif input == ""
        p "enter key(return) is not a valid command. "
        puts "\n"
        p "Use the following commands : \n"
        puts "\n"
        Person.help_menu
        puts "\n\n"

          
      else
        input = input.split(" ")
        if input[0] == "new" && input[1] == "user"  
          u = User.new(input[2], input[3], input[4])
          user_list << u
          
          puts u.name + "(#{u.credit_limit})"

        elsif input[0] == "new" && input[1] == "merchant"
          # if input[2].class== "String" && input[2].include?("@")
          #   email=input[2]
          #   discount_percentage=input[3].to_f        
          # end
          m = Merchant.new(input[2], input[3])
          merchant_list << m

          puts m.name + "(#{m.discount_percentage})"

      
        elsif input[0] == "new" && input[1] == "txn" 
      
          user=user_list.select{|user| user.name== input[2]}
          merchant=merchant_list.select{|merchant| merchant.name == input[3]}
          unless user.first.nil? || merchant.first.nil?
            check= user.first.transact(input[4].to_f)
            merchant.first.update_total_discount(input[4].to_f) if check
          else
                p "#{input[2]} : not found" if user.first.nil?
                p "#{input[3]} : not found" if merchant.first.nil?  
          end
          
      
        elsif input[0]== "update" && input[1] == "merchant"
          update_merchant=merchant_list.select{|merchant| merchant.name == input[2]}
          unless update_merchant.first.nil?
            update_merchant.first.update_discount_percentage(input[3].to_f)
          else
             p "#{input[2]} : not found"   
          end     
          

        elsif input[0] == "payback"
          payback_user=user_list.select{|user| user.name== input[1]}
          unless payback_user.first.nil?
            payback_user.first.payback(input[2].to_f)
          else
           p "#{input[1]} : not found"   
          end
          
        elsif (input[0] == "report" && input[1]=="dues")        
          user_dues=user_list.select{|user| user.name== input[2]}
          unless user_dues.first.nil?
            puts user_dues.first.report_user_dues
          else
           p "#{input[2]} : not found"
          end

        elsif (input[0] == "report" && input[1]=="total-dues")
          total_dues=0
          for user in user_list do
            total_dues+=user.dues
            p "#{user.name} : #{user.dues}"
          end
            p "Total : #{total_dues}"


        elsif (input[0] == "report" && input[1]=="users-at-credit-limit")

          User.users_at_credit_limit(user_list)
         
         elsif input[0]== "update" && input[1] == "user"
          update_user=user_list.select{|user| user.name== input[2]}
          unless update_user.first.nil?
            update_user.first.update_credit_limit(input[3].to_f)
          else
            p "#{input[2]} : not found"
          end

        elsif input[0]=="report" && input[1]=="discount"
          discount_for_merchant=merchant_list.select{|merchant| merchant.name == input[2]}
          unless discount_for_merchant.first.nil?
            puts discount_for_merchant.first.total_discount
          else
            p "#{input[2]} : not found"
          end
          
        elsif input[0]=="-h"
          Person.help_menu
        else
          p "Not a Recognized Command :  use '-h' for command list"
        end
      end
    end
    

    
    

    