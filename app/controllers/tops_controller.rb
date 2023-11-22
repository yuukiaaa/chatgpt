class TopsController < ApplicationController
    def index

    end

    def message
        @response = {}
        for role in ['ソクラテス', 'プラトン', 'アリストテレス'] do
            chatgpt = ChatgptService.new(message=params[:message], role=role)
            message = chatgpt.message
            @response.store(role, message)
        end
        respond_to do |format|
            format.json { render json: @response }
        end
    end

end
