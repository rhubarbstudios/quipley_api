require 'sinatra'
require 'httparty'


get '/' do
  url = 'http://dev.quipley.com/api/rhb/needs'
  resp = HTTParty.get(url)
  needs_resp = resp.parsed_response
  puts needs_resp
  @needs = needs_resp["needs"]

  erb :index
end

get '/register' do
  @need_name = params['need_name']
  @need_id = params['need_id']
  erb :register
end

post '/register' do

  @need_id = params['need_id']
  email = params['email']
  password = params['mobile'].gsub(/\D/, '')

  user_options = {
    body: {
      last_name: params['last_name'],
      first_name: params['first_name'],
      name: params['name'],
      email: params['email'],
      mobile: params['mobile'],
      password: password,
      password_confirmation: password
    }
  }
  user_post_url = 'http://dev.quipley.com/api/v1/merchants/users'
  user_resp = HTTParty.post(user_post_url, user_options)
  user_resp_parsed = user_resp.parsed_response


  user_id = user_resp_parsed['data']['user']['id']
  merchant_id = user_resp_parsed['data']['merchant']['id']
  activation_code = user_resp_parsed['data']['activationCode']

  activate_post_url = "http://dev.quipley.com/api/v1/activate/#{user_id}/#{activation_code}"
  activate_resp = HTTParty.put(activate_post_url)
  activate_resp_parsed = activate_resp.parsed_response


  login_url = 'http://dev.quipley.com/api/v1/users/authenticate'
  login_options = {
    body: {
      email: email,
      password: password
    }
  }
  login_resp = HTTParty.post(login_url, login_options)
  session_cookie = login_resp.headers['set-cookie']

  if activate_resp_parsed['status']['code'] == 200
    locations_post_url = "http://dev.quipley.com/api/v1/merchants/#{merchant_id}/locations"
    location_options = {
      body: {
        address_line_1: params['street'],
        city: params['city'],
        state: params['state'],
        postal_code: params['zip'],
        country: 'USA'
      },
      headers: {
        'Cookie' => session_cookie
      }
    }

    location_resp = HTTParty.post(locations_post_url, location_options)
    location_resp_parsed = location_resp.parsed_response
    location_id = location_resp_parsed['data']['id']

  end

  if location_resp.code == 200
    programs_post_url = "http://dev.quipley.com/api/v1/needs/#{@need_id}/programs"
    program_options = {
      body: {
        location_id: location_id,
        name: params['name'],
        promised_amount: params['promised_amount'],
        promised_percentage: params['promised_percentage'],
        start_date: params['start_date'],
        end_date: params['end_date'],
        product_discount_amount: params['product_discount_amount']
      },
      headers: {
        'Cookie' => session_cookie
      }
    }
    program_resp = HTTParty.post(programs_post_url, program_options)

  end

  redirect "/"
end
