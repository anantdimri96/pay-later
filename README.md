# pay-later

# About
As a pay later service we allow our users to buy goods from a merchant now, and then allow them to pay for those goods at a later date.<br/>

The service works inside the boundary of following simple constraints - <br/>
  Let's say that for every transaction paid through us, merchants offer us a discount.<br/> 
  For example, if the transaction amount is Rs.100, and merchant discount offered to us is 10%, we pay Rs. 90 back to the   merchant. <br/>
The discount varies from merchant to merchant. <br/>
  A merchant can decide to change the discount it offers to us, at any point in time. <br/>
  All users get onboarded with a credit limit, beyond which they can't transact. <br/>
  If a transaction value crosses this credit limit, we reject the transaction. <br/>

# Setup

Installation of  ruby. Link for reference: https://gorails.com/setup/ubuntu/16.04#ruby

Dependencies for ruby<br/>
```bash
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn
```
Installing ruby using rbenv
```bash
cd
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

rbenv install 2.6.1
rbenv global 2.6.1
ruby -v
```



## Usage

clone the repository

cd path/to/cloned_folder

```bash
  ruby pay_later_service.rb
  ```
