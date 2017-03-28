require 'sinatra'   # gem 'sinatra'
require 'line/bot'  # gem 'line-bot-api'

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["3690260592cceae21e707afad6fc11ae"]
    config.channel_token = ENV["lNYfFnxcshESFEcAEG9ymSRjlyAm/jWvABqyfjmad+ZkiXyjt5IGecZwKV8Oh8RsmJLUqVRWW4q6f9SUseHYGg2NzPmRF5FDg1GV0AGD14XLQvv85HVCv7krwH5Q9L11m4m2kdU2RHnKgn71RxJv1AdB04t89/1O/w1cDnyilFU="]
  }
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)

  events.each { |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        message = {
          type: 'text',
          text: event.message['text']
        }
        client.reply_message(event['replyToken'], message)
      end
    end
  }

  "OK"
end
