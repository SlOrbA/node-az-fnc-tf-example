module.exports = function (context, req) {
	context.log('hello call triggered with ' + req.method + ' method');
	context.res =  {
		body: "Hello World!";
	};
}
