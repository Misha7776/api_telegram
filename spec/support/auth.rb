def auth_headers(user)
  headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
  Devise::JWT::TestHelpers.auth_headers(headers, user)
end

def authenticated_header(request, admin)
  token = JsonWebToken.encode(admin_id: admin.id)
  request.headers.merge!('Authorization': "Bearer #{token}")
end
