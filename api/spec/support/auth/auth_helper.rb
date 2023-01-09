# frozen_string_literal: true

module ::Auth
  SIGN_IN_HEADER = { 'Content-Type': 'application/json' }.freeze

  def sign_in_common_user
    @sign_in_common_user ||= sign_in(common_user.slice(:email, :password))
  end

  def sign_in_admin_user
    @sign_in_admin_user ||= sign_in(admin_user.slice(:email, :password))
  end

  def common_user
    @common_user ||= User.create!(
      name: 'Teste',
      email: 'teste@teste.com',
      password: '123456',
      password_confirmation: '123456',
      role: 0
    )
  end

  def admin_user
    @admin_user ||= User.create!(
      name: 'Other Teste',
      email: 'other_teste@teste.com',
      password: '123456',
      password_confirmation: '123456',
      role: 1
    )
  end

  def sign_in(credentials)
    post(
      user_session_path,
      params: {
        email: credentials[:email],
        password: credentials[:password]
      }.to_json, headers: SIGN_IN_HEADER
    )
    {
      body: JSON.parse(
        response.body,
        symbolize_names: true
      ),
      headers: response.headers
    }
  end
end
