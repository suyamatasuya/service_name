class OauthsController < ApplicationController
    include Sorcery::Controller::Submodules::External
    skip_before_action :require_login, raise: false
  
    # OAuth 認証の開始
    def oauth
      login_at(params[:provider])
    end
  
    # OAuth 認証のコールバック
    def callback
      provider = params[:provider]
  
      # デバッグログの追加
      Rails.logger.debug "Provider: #{provider}"
  
      # 既存のユーザーを検索
      @user = login_from(provider)
  
      # 既存のユーザーが見つからない場合
      unless @user
        # デバッグログの追加
        Rails.logger.debug "login_from returned nil for provider: #{provider}"
  
        begin
          # 新規ユーザーを作成
          @user = create_from(provider)
  
          # エラーハンドリング
          unless @user
            redirect_to root_path, alert: "#{provider.titleize}でのユーザー登録に失敗しました"
            return
          end
  
          # ユーザーをデータベースに保存
          @user.save!
  
          # デバッグログの追加
          Rails.logger.debug "User created from provider: #{@user.inspect}"
        rescue => e
          # エラーメッセージのログ出力
          Rails.logger.error "Error during create_from: #{e.message}"
          redirect_to root_path, alert: "#{provider.titleize}でログインに失敗しました"
          return
        end
      end
  
      # ユーザーをログインさせる
      reset_session
      auto_login(@user)
      redirect_to root_path, notice: "#{provider.titleize}でログインしました"
    end
  end
  