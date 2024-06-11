# README

One of the central components of our system is the Booking class which has a `guest_price` method that calculates the current price based on the booking components (stay nights, discounts, transfers etc.). In turn, the booking can be later cancelled and/or modified to change the guests, rooms, duration etc. This is currently stored as ModificationRequest and CancellationRequest. Once the corresponding request is approved, changes are applied to the booking and `guest_price` will be returning updated value.

Now, the challenge is that we do not store previous booking prices and cannot easily see the history of the changes. We would like to start tracking this and adjust our reporting to use historical values as required. Whenever change is applied to the booking, we would first capture the current `guest_price` and store it for analytical purposes.

You can create dummy bookings, cancellation_requests and modification_requests tables/models since the actual work is about introducing the new process to track those changes. As a result of this change we should be able to call `booking.price_changes` and see the history of the price changes. Importantly, we should be able to also see the results in aggregate. For example, what is the total price of all bookings that were created in April at a particular point in time. Let's say there were 100 bookings created during April 1-20 each for $1000, and 10 of them were cancelled on 25th April. As of May 14 total value of the bookings is 90 * $1000 = $90K. However, as of April 24, the total value is $100K.

As you can see, the project is somewhat intentionally vague. This is done for 2 reasons:
1) so that you can adjust the scope up/down as required to fit ~2 days
2) to give you an opportunity to make design decisions yourself. Normally, I would want to discuss those decisions to make sure you have the right understanding of the underlying business, but for the purposes of test assignment it is not important. What is important is to go through those decisions with you when we review the assignment, e.g. we will want to hear why you chose one or the other way. We are not looking for the "correct" answer, but want to give a chance to express your thoughts. In other words, on a real project you will have questions before you can proceed, but here you can simply invent answers yourself on our behalf if you are not sure.

We'd appreciate clear write-up about your decision where it is possible (comments in code and/or separate notes)


