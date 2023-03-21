class ApplicationController < ActionController::API
    before_action :authorized

  def encode_token(payload)
    # should store secret in env variable
    JWT.encode(payload, 'my_s3cr3t')
  end

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      # header: { 'Authorization': 'Bearer <token>' }
      begin
        JWT.decode(token, 'my_s3cr3t', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!current_user
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end
      #fetch on react

    #   fetch("http://localhost:3000/api/v1/profile", {
    #     method: "GET",
    #     headers: {
    #       Authorization: `Bearer <token>`,
    #     },
    #   });

    #creating user react fetch

    # fetch("http://localhost:3000/api/v1/users", {
    #     method: "POST",
    #     headers: {
    #       "Content-Type": "application/json",
    #       Accept: "application/json",
    #     },
    #     body: JSON.stringify(newUserData),
    #   })
    #     .then((r) => r.json())
    #     .then((data) => {
    #       // save the token to localStorage for future access
    #       localStorage.setItem("jwt", data.jwt);
    #       // save the user somewhere (in state!) to log the user in
    #       setUser(data.user);
    #     });

    # A sample request might look like:

# const token = localStorage.getItem("jwt");

# fetch("http://localhost:3000/api/v1/profile", {
#   method: "GET",
#   headers: {
#     Authorization: `Bearer ${token}`,
#   },
# });

end
