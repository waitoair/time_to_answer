namespace :dev do

  DEFAULT_PASSWORD = 123456

  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando Database") { %x(rails db:drop) }
      show_spinner("Criando Database") { %x(rails db:create) }
      show_spinner("Migrando Database") { %x(rails db:migrate) }
      show_spinner("Criando o Administrador Padrão...") { %x(rails dev:add_default_admin) }
      show_spinner("Criando o Usuário Padrão...") { %x(rails dev:add_default_user) }
      # %x(rails dev:add_coins)
      # %x(rails dev:add_mining_type)
    else
      "Voce não está em ambiente de desenvolvimento"
    end
  end

  desc "Adiciona o Administrador Padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com.br',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona o Usuário Padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com.br',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  private

  def show_spinner(starting_msg, ending_msg = "Conlcuído")
    spinner = TTY::Spinner.new("[:spinner] #{starting_msg}...")
    spinner.auto_spin
    yield
    spinner.success("#{ending_msg}!")
  end
end
