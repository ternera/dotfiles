# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.

source $HOME/.aliases

export PATH="$PATH:$HOME/.rvm/bin"

if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  export PATH=`gem environment gemdir`/bin:$PATH
fi

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"