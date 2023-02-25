class UsersController < ApplicationController
  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end

  def create
    user = User.new

    user.username = params.fetch("input_username")
    user.password = params.fetch("input_password")
    user.password_confirmation = params.fetch("check_pass")

    save_status = user.save
    
    if save_status == true
      session.store(:user_id, user.id )
      

      redirect_to("/users/#{user.username}", { :notice => "Welcome, " + user.username + "!"})
    else
      redirect_to("/user_sign_up", {:alert => user.errors.full_messages.to_sentence})   
    end
    

    # redirect_to("/users/#{user.username}")
  end

  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)


    user.username = params.fetch("input_username")

    user.save
    
    redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end

  def signin

    render({:template=> "/users/signin.html.erb"})
  end


  def signup

    render({:template=> "/users/signup.html.erb"})
  end

  def signout
    reset_session

    redirect_to("/", {:notice => "See ya later!"})

  end

  def verify_credentials
    # get the username from params
    # get the password from params

    # look up the record from the db matching username
    # if there's no record, redirect back to sign in form

    # if there is a record, check to see if password matches
    # if not, redirect back to sign in form

    # if so, set the cookie
    # redirect to home page


    a_name = params.fetch("username")
    a_pass = params.fetch("password")

    this_user = User.where(:username => a_name).first

    if this_user == nil

      redirect_to("/user_sign_in", {:alert => "No one by that name round these parts"})
    else
  
      if  this_user.authenticate(a_pass)  

      session.store(:user_id, this_user.id)
      #redirect_to("/users/#{this_user.username}", {:notice=> "Welcome back, #{this_user.username}!"})
      redirect_to("/", {:notice=> "Welcome back, #{this_user.username}!"})
      else
        redirect_to("/user_sign_in", {:alert => "Nice try, sucker!"})
      end
    end

    # this_user.password_confirmation


    # redirect_to("/", {:notice => "See ya later!"})

  end
end
