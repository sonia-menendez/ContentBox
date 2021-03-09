﻿/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	function run( testResults, testBox ){
		// all your suites go here.
		describe( "Comment Service", function(){
			aroundEach( function( spec, suite ){
				ormClearSession();
				try {
					// Make sure we always rollback
					transaction {
						arguments.spec.body();
					}
				} catch ( any e ) {
					transactionRollback();
					rethrow;
				}
			} );

			beforeEach( function( currentSpec ){
				commentService = getInstance( "CommentService@cb" );
			} );

			it( "can get approved comment count", function(){
				var r = commentService.getApprovedCount();
				expect( r ).toBeGT( 0 );
			} );

			it( "can get unapproved comment count", function(){
				var r = commentService.getUnApprovedCount();
				expect( r ).toBeGT( 0 );
			} );

			describe( "Approved Comment Finders", function(){
				it( "cand find all", function(){
					var r = commentService.findAllApproved();
					expect( r.count ).toBeGT( 0 );
				} );
				it( "can find by content ID", function(){
					var r = commentService.findAllApproved( contentID = 0 );
					expect( r.count ).toBe( 0 );

					var r = commentService.findAllApproved( contentID = 142 );
					expect( r.count ).toBeGT( 0 );
				} );
				it( "can find by content types", function(){
					var r = commentService.findAllApproved( contentType = "invalid" );
					expect( r.count ).toBe( 0 );

					var r = commentService.findAllApproved( contentType = "Entry" );
					expect( r.count ).toBeGT( 0 );
				} );
			} );

			it( "can do comment searching by parameters", function(){
				// test get all
				var r = commentService.search();
				expect( r.count ).toBeGT( 0 );

				// test any approved
				var r = commentService.search( isApproved = "any" );
				expect( r.count ).toBeGT( 0 );

				var r = commentService.search( isApproved = false );
				expect( r.count ).toBe( 1 );

				var r = commentService.search( contentID = 142 );
				expect( r.count ).toBeGT( 0 );

				// disjunction with content
				var r = commentService.search( contentID = 142, search = "awesome" );
				expect( r.count ).toBeGTE( 1 );
				// disjunction with author
				var r = commentService.search( contentID = 142, search = "luis" );
				expect( r.count ).toBeGTE( 1 );
				// disjunction with authorEmail
				var r = commentService.search( contentID = 142, search = "lmajano@gmail.com" );
				expect( r.count ).toBeGTE( 1 );
			} );
		} );
	}

}
