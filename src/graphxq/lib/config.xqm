(:~ 
:  configuration access
:  looks in  WEB-INF/site-config.xml for actual values
:
: @author andy bunce
: @since sept 2012
:)

module namespace config = 'apb.config';
declare default function namespace 'apb.config';
declare variable $config:default:=
<config>
    <libserver>//cdnjs.cloudflare.com/ajax/libs</libserver>
     <aceserver>http://d1n0x3qji82z53.cloudfront.net</aceserver>
    <twitter>
        <CONSUMER-KEY>CONSUMER-KEY</CONSUMER-KEY>
        <CONSUMER-SECRET>CONSUMER-SECRET</CONSUMER-SECRET>
        <access-token>your token</access-token>
        <access-token-secret>your secret</access-token-secret>
    </twitter>
</config>
;
declare variable $config:config:=
                            fn:doc(fn:resolve-uri("../../WEB-INF/site-config.xml"))/config
                            ;
                            
(:
:  /twitter-bootstrap/2.1.1/..
:  /jquery/1.8.1/jquery.min.js
:)
declare variable $config:libserver as xs:string:=$config:config/libserver/fn:string();

declare variable $config:aceserver as xs:string:=$config:config/aceserver/fn:string();