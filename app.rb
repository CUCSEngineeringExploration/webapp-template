enable :sessions

def got_answer(params, session)
  if params[:yes]
    session[:low]  = session[:pivot] + 1
  end

  if params[:no]
    session[:high] = session[:pivot]
  end

  session[:pivot] = (session[:high] + session[:low])/2

  if session[:low] == session[:high]
    return {answer: "Your number was #{session[:low]}"}
  else
    return {question: "Is your number bigger or equal to #{session[:pivot]+1}?"}
  end
end

get '/' do
  session[:low]  = 0
  session[:high] = 1023
  session[:num_questions] = 0
  session[:answers] = ""

  <<-CONTENT
    Let's guess some numbers!
    <form action="/guess" method="post">
      <input type="submit" value="Start" />
    </form>
  CONTENT
end

post '/guess' do
  res = got_answer(params, session)

  session[:answers] += "#{params.values.first} "

  if res[:answer]
    <<-CONTENT
      #{res[:answer]}
      <br />
      #{session[:answers]}
      <form action="/" method="get">
        <input type="submit" value="Try Again!" />
      </form>
    CONTENT
  else
    <<-CONTENT
      <strong>Question #{session[:num_questions] += 1}</strong><br/>
      #{res[:question]}

      <form action="/guess" method="post">
        <input type="submit" value="Yes" name="yes" />
        <input type="submit" value="No"  name="no" />
      </form>

      <br />
      #{session[:answers]}

      <form action="/" method="get">
        <input type="submit" value="Try Again!" />
      </form>
    CONTENT
  end
end
