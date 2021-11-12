#!/bin/bash
set -e

export PATH=$PATH:/var/vcap/packages/elasticsearch/bin

<% if_p('elasticsearch.secure_settings') do |secure_settings| %>
echo "== Configure secure settings =="
<% secure_settings.each do |setting| %>
echo "<%= setting['command'] %>: <%= setting['name'] %>"
<% if setting['command'] == 'add' then %>
echo "<%= setting['value'] %>" | elasticsearch-keystore add -xf  <%= setting['name'] %>
<% elsif setting['command'] == 'add-file'  %>
elasticsearch-keystore add-file -f <%= setting['name'] %> <%= setting['value'] %>
<% elsif setting['command'] == 'remove'  %>
elasticsearch-keystore remove <%= setting['name'] %> || true
<% end %>
chown vcap:vcap /var/vcap/packages/elasticsearch/config/elasticsearch.keystore
<% end %>
echo "== Secure settings =="
elasticsearch-keystore list || true
<% end %>