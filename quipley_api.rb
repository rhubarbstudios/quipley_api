require 'sinatra'
require 'httparty'
require 'madison'
require 'dotenv'

Dotenv.load

get '/' do
  puts ENV['API_URL']
  url = ENV['API_URL'] + "rhb/needs"
  puts url
  resp = HTTParty.get(url)
  needs_resp = resp.parsed_response
  @needs = needs_resp["needs"]
  if ENV['API_DB'] == "development"
    @needs = @needs.first(5)
  end

  if params['confirm'] == true
    @success_message = "Your event has been submitted."
  elsif params['confirm'] == false
    puts "-------------------------------------"
    puts "FAIL"
    puts "-------------------------------------"
  end

  erb :index
end

get '/register' do
  @need_name = params['need_name']
  @need_id = params['need_id']
  @need_community_name = params['need_community_name']
  erb :register
end

post '/register' do

  @need_id = params['need_id']
  email = params['email']
  password = params['mobile'].gsub(/\D/, '')

  def fail_redirect(reason)
    puts "REASON FOR FAIL:"
    puts reason
    puts "-----------------"
    redirect "/?confirm=false"
  end

  def create_user(email, password)
    user_options = {
      body: {
        last_name: params['last_name'],
        first_name: params['first_name'],
        name: params['name'],
        email: email,
        mobile: params['mobile'],
        password: password,
        password_confirmation: password
      }
    }
    user_post_url = ENV['API_URL'] + "v1/merchants/users"
    user_resp = HTTParty.post(user_post_url, user_options)
    user_resp_parsed = user_resp.parsed_response

    puts "-----------------------------------------------------"
    puts "NEW USER POST RESPONSE"
    puts user_resp_parsed
    puts "-----------------------------------------------------"

    if user_resp_parsed['status']['code'] == "201"
      user_id = user_resp_parsed['data']['user']['id']
      merchant_id = user_resp_parsed['data']['merchant']['id']
      activation_code = user_resp_parsed['data']['activationCode']

      activate_user(user_id, activation_code, email, password, merchant_id)
    else
      puts "CREATE USER FAILED"
      fail_redirect("Could not create user")
    end

  end

  def activate_user(user_id, activation_code, email, password, merchant_id)
    activate_post_url = ENV['API_URL'] + "v1/activate/#{user_id}/#{activation_code}"
    activate_resp = HTTParty.put(activate_post_url)
    activate_resp_parsed = activate_resp.parsed_response

    puts "-----------------------------------------------------"
    puts "USER ID:"
    puts user_id

    puts "CODE:"
    puts activation_code

    puts "ACTIVATION PUT RESPONSE"
    puts activate_resp_parsed
    puts "-----------------------------------------------------"

    if activate_resp_parsed['status']['code'] == 200
      login_user(email, password, merchant_id)
    else
      puts "USER ACTIVATION FAILED"
      fail_redirect("Could not activate user")
    end

  end

  def login_user(email, password, merchant_id)
    login_url = ENV['API_URL'] + "v1/users/authenticate"
    login_options = {
      body: {
        email: email,
        password: password
      }
    }

    login_resp = HTTParty.post(login_url, login_options)
    login_resp_parsed = login_resp.parsed_response

    puts "-----------------------------------------------------"
    puts "LOGIN POST RESPONSE"
    puts login_resp_parsed
    puts "COOKIE"
    puts login_resp.headers['set-cookie']
    puts "-----------------------------------------------------"

    if login_resp_parsed['status']['code'] == 200
      session_cookie = login_resp.headers['set-cookie']
      create_location(merchant_id, session_cookie)
    else
      puts "USER LOGIN FAILED"
      fail_redirect("Could not login user")
    end

  end

  def create_location(merchant_id, session_cookie)
    locations_post_url = ENV['API_URL'] + "v1/merchants/#{merchant_id}/locations"
    location_options = {
      body: {
        address_line_1: params['street'],
        city: params['city'],
        state: params['state'],
        postal_code: params['zip'],
        country: params['country']
      },
      headers: {
        'Cookie' => session_cookie
      }
    }

    location_resp = HTTParty.post(locations_post_url, location_options)
    location_resp_parsed = location_resp.parsed_response

    puts "-----------------------------------------------------"
    puts "LOCATION POST RESPONSE"
    puts location_resp_parsed
    puts "-----------------------------------------------------"

    if location_resp_parsed['status']['code'] == 200
      location_id = location_resp_parsed['data']['id']
      create_program(@need_id, location_id, session_cookie)
    else
      puts "CREATE LOCATION FAILED"
      fail_redirect("Could not create location")
    end

  end

  def create_program(need_id, location_id, session_cookie)
    programs_post_url = ENV['API_URL'] + "v1/needs/#{@need_id}/programs"
    program_options = {
      body: {
        location_id: location_id,
        name: params['name'],
        promised_amount: params['promised_amount'],
        promised_percentage: params['promised_percentage'],
        start_date: params['start_date'],
        end_date: params['start_date'],
        # what is product_discount_amount?
        product_discount_amount: params['product_discount_amount']
      },
      headers: {
        'Cookie' => session_cookie
      }
    }

    program_resp = HTTParty.post(programs_post_url, program_options)
    program_resp_parsed = program_resp.parsed_response

    puts "-----------------------------------------------------"
    puts "PROGRAM RESPONSE"
    puts program_resp_parsed
    puts "-----------------------------------------------------"

    if program_resp_parsed['status']['code'] == "201"
      redirect "/?confirm=true"
    else
      puts "CREATE PROGRAM FAILED"
      fail_redirect("Could not create program")
    end

  end

  create_user(email, password)



end
