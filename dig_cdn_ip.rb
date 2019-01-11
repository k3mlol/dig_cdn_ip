#!/usr/bin/env ruby
#encoding:utf-8
#author: k3m
#description: find a website host on which ip
require 'yaml'
require 'faraday'
require 'nokogiri'
require 'digest'

def load_yml(config_file)
    data = YAML.load_file(config_file)
    #puts data
    return data
end


def get_url_title(url)
    conn = Faraday.new(:url => url, :ssl => {:verify => false}, request: {open_timeout: 2, timeout: 5})
    begin
        response = conn.get '/'
        page = Nokogiri::HTML(response.body)
        title = page.css('title').text
        return title
    rescue => exception
        #puts "ERROR:" + url.to_s
    end
end

def compare_title(original_title, url)
    original_title = original_title.gsub(' ','')
    title = get_url_title(url)
    if title == nil
        return false
    else
        if original_title == title
            return true
        else
            return false
        end
    end
end


# masscan the network block
def masscan_helper(netblock)
    # masscan -p80,443 10.0.0.0/8 -oX <filename>
    # md5 the netblock
    md5 = Digest::MD5.new
    md5.update netblock
    puts "start scanning " + netblock
    command = "sudo masscan -p80,443 " + netblock + " -oX " + md5.hexdigest + ".xml"
    if system(command)
        return md5.hexdigest.to_s + '.xml'
    else
        return nil
    end
end

# prase tht result
def masscan_parsexml(xml_file)
    result = Array.new
    xml_doc  = Nokogiri::XML(File.open(xml_file))
    xml_doc.xpath('//host').each do |host|
        #puts host
        ip = host.css('address').attr('addr').to_s
        #puts host.css('address')
        #puts ip
        #puts "------"
        host.css('port').each do |port|
            p = port.attr('portid').to_s
            if p == '443'
                result.push("https://" + ip + ":" + p)
            end
            if p == "80"
                result.push("http://" + ip + ":" + p)
            end
        end
    end
    return result
end

data = load_yml(ARGV.first)
data['scan_ip_block'].each do |ip_block|
    xml_file = masscan_helper(ip_block)
    urls = masscan_parsexml(xml_file)
    urls.each do |url|
        #puts url
        #puts get_url_title(url)
        if compare_title(data['website_factor']['title'], url)
            puts "----------- FOUND"
            puts url
            puts "------"
            break
        end
    end
end