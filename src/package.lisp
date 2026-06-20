;;;; package.lisp - Package definitions for clatter-irc

(in-package :cl-user)

(defpackage #:clatter-irc
  (:use #:cl)
  (:nicknames #:irc2)
  (:documentation "Modern IRC client library with IRCv3 support")
  
  ;; Connection management
  (:export
   #:connection
   #:make-connection
   #:connect
   #:disconnect
   #:connectedp
   #:send-raw
   #:connection-nick
   #:connection-server
   #:connection-port
   #:connection-state
   #:connection-channels
   #:connection-tls-p
   #:connection-username
   #:connection-sasl-username
   #:connection-sasl-password
   #:connection-user-data
   #:connection-cap-enabled
   
   ;; Connection internals (for subclassing)
   #:connection-stream
   #:connection-socket
   #:connection-read-thread
   #:connection-write-lock
   #:connection-last-activity
   #:connection-reconnect-enabled
   #:connection-reconnect-attempts
   #:connection-hooks
   
   ;; Connection options
   #:with-connection
   #:*default-port*
   #:*default-tls-port*
   #:*default-quit-message*
   #:*default-realname*)
  
  ;; IRC Commands
  (:export
   #:nick
   #:user-
   #:pass
   #:join
   #:part
   #:quit
   #:privmsg
   #:notice
   #:kick
   #:mode
   #:topic
   #:invite
   #:names
   #:list-channels
   #:who
   #:whois
   #:whowas
   #:ping
   #:pong
   #:away
   #:userhost
   #:ison
   #:ctcp
   #:ctcp-reply)
  
  ;; Message parsing
  (:export
   #:parse-message
   #:message
   #:message-prefix
   #:message-command
   #:message-params
   #:message-tags
   #:message-raw
   #:prefix-nick
   #:prefix-user
   #:prefix-host
   #:parse-prefix
   #:format-message
   #:get-tag
   #:get-server-time)
  
  ;; IRCv3 support
  (:export
   #:cap-request
   #:cap-end
   #:cap-enabled-p
   #:enabled-capabilities
   #:*wanted-capabilities*
   #:sasl-authenticate
   #:sasl-plain
   #:sasl-external)
  
  ;; Event/Hook system
  (:export
   #:add-hook
   #:remove-hook
   #:remove-all-hooks
   #:define-handler
   #:*hooks*
   
   ;; Standard hook names
   #:on-connect
   #:on-disconnect
   #:on-message
   #:on-privmsg
   #:on-notice
   #:on-join
   #:on-part
   #:on-quit
   #:on-kick
   #:on-nick
   #:on-mode
   #:on-topic
   #:on-invite
   #:on-error
   #:on-numeric
   #:on-ctcp
   #:on-ctcp-reply
   #:on-raw)
  
  ;; DCC
  (:export
   #:dcc-manager
   #:make-dcc-manager
   #:dcc-chat
   #:dcc-send
   #:dcc-receive
   #:dcc-initiate-chat
   #:dcc-initiate-send
   #:dcc-handle-offer
   #:dcc-chat-send
   #:dcc-accept
   #:dcc-reject
   #:dcc-close
   #:dcc-list
   #:dcc-connection
   #:dcc-state
   ;; Connection / transfer accessors used by clients
   #:dcc-connection-id
   #:dcc-connection-nick
   #:dcc-connection-state
   #:dcc-connection-direction
   #:dcc-connection-error-message
   #:dcc-chat-on-message
   #:dcc-send-filename
   #:dcc-send-filesize
   #:dcc-send-bytes-transferred
   #:dcc-send-on-progress
   ;; Hooks
   #:on-dcc
   #:on-dcc-chat
   #:on-dcc-send
   #:*dcc-download-directory*
   #:*dcc-port-range*)
  
  ;; Channel tracking
  (:export
   #:channel
   #:make-channel
   #:channel-name
   #:channel-topic
   #:channel-topic-who
   #:channel-topic-time
   #:channel-users
   #:channel-modes
   #:channel-created
   #:channel-joined-at
   ;; Channel user
   #:channel-user
   #:make-channel-user
   #:user-nick
   #:user-prefix-modes
   #:user-account
   #:user-host
   ;; Channel operations
   #:channel-add-user
   #:channel-remove-user
   #:channel-find-user
   #:channel-rename-user
   #:channel-user-count
   #:channel-user-list
   #:channel-user-nicks-with-prefix
   #:parse-nick-with-prefix
   ;; Connection-level channel management
   #:find-channel
   #:ensure-channel
   #:remove-channel
   #:joined-channels
   #:joined-channel-p
   ;; Connection channel-class option
   #:connection-channel-class)
  
  ;; Utilities
  (:export
   #:sanitize-input
   #:channel-name-p
   #:valid-channel-name-p
   #:valid-nick-p
   #:strip-formatting
   #:normalize-channel
   #:normalize-nick
   #:nick-equal
   #:mask-matches-p
   #:split-message
   #:format-irc-line
   #:format-tags
   #:ip-string-to-integer
   #:ip-integer-to-string
   #:format-datetime
   #:run-hooks)
  
  ;; Conditions
  (:export
   #:irc-error
   #:connection-error
   #:authentication-error
   #:protocol-error))

(defpackage #:clatter-irc.protocol
  (:use #:cl)
  (:documentation "Low-level IRC protocol parsing and formatting")
  (:export
   #:parse-raw-message
   #:format-irc-line
   #:parse-irc-tags
   #:format-irc-tags
   #:parse-prefix
   #:sanitize-irc-input
   #:validate-irc-input
   #:strip-irc-formatting
   #:channel-name-p
   #:valid-channel-name-p
   #:ip-string-to-integer
   #:ip-integer-to-string))

(defpackage #:clatter-irc.dcc
  (:use #:cl)
  (:documentation "DCC (Direct Client-to-Client) protocol support")
  (:export
   #:dcc-manager
   #:make-dcc-manager
   #:dcc-connection
   #:dcc-chat
   #:dcc-send
   #:dcc-initiate-chat
   #:dcc-initiate-send
   #:dcc-accept
   #:dcc-reject
   #:dcc-close
   #:dcc-handle-offer
   #:*dcc-manager*
   #:*dcc-download-directory*
   #:*dcc-port-range-start*
   #:*dcc-port-range-end*
   #:get-local-ip
   #:set-dcc-ip))
