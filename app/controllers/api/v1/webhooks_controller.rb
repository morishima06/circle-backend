# frozen_string_literal: true

module Api
  module V1
    class WebhooksController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        payload = request.body.read
        sig_header = request.env['HTTP_STRIPE_SIGNATURE']

        event = Stripe::Webhook.construct_event(
          payload,
          sig_header,
          ENV.fetch('STRIPE_WEBHOOK_SECRET', nil)
        )

        payment_intent = event.data.object

        case event.type
        when 'payment_intent.succeeded',
             'payment_intent.payment_failed'
          payment = Payment.find_by!(
            stripe_payment_intent_id: payment_intent.id
          )

          Payments::StatusUpdateService.call(payment, payment_intent)
        end

        head :ok
      rescue Stripe::SignatureVerificationError
        render json: { error: 'invalid signature' }, status: :bad_request
      rescue StandardError
        head :ok
      end
    end
  end
end
