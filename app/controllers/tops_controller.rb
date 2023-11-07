class TopsController < ApplicationController
    def index

    end

    def message
        chatgpt = ChatgptService.new(message=params[:message])
        @response = chatgpt.message

        respond_to do |format|
            format.json { render json: @response }
        end
    end

end
