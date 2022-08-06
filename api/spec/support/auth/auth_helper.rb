module Auth
  SIGN_IN_HEADER = {"Content-Type": "application/json"}
  def sign_in(user: nil)
    create_users_default if User.count.zero?
    user = {email: 'teste@teste.com', password: '123456'} if user.nil?
    post user_session_path, params: {:email => user[:email], :password => user[:password]}.to_json, headers: SIGN_IN_HEADER
    {body: JSON.parse(response.body, symbolize_names: true), headers: response.headers }
  end

  def create_users_default
    User.create!(
      name:                   "Teste",
      email:                  "teste@teste.com",
      password:               "123456",
      password_confirmation:  "123456",
      role:                   0
    )
    
    User.create!(
      name:                   "Other Teste",
      email:                  "otherteste@teste.com",
      password:               "123456",
      password_confirmation:  "123456",
      role:                   1
    )
  end
end