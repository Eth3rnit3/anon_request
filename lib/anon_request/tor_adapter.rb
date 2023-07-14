# frozen_string_literal: true

class TorAdapter
  def net_http_connection(env)
    if (proxy = env[:request][:proxy])
      proxy_class(proxy)
    else
      Net::HTTP
    end.new(env[:url].hostname, env[:url].port || (env[:url].scheme == 'https' ? 443 : 80))
  end

  def proxy_class(proxy)
    if proxy.uri.scheme == 'socks5'
      TCPSocket.socks_username = proxy.uri.user if proxy.uri.user
      TCPSocket.socks_password = proxy.uri.password if proxy.uri.password
      Net::HTTP::SOCKSProxy(proxy[:uri].host, proxy[:uri].port)
    else
      Net::HTTP::Proxy(proxy[:uri].host, proxy[:uri].port, proxy[:uri].user, proxy[:uri].password)
    end
  end
end
