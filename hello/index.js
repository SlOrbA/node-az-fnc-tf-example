module.exports = async function (context, req) {
	context.log('hello call triggered with ' + req.method + ' method');
	return {
		body: "Hello World!";
	};
}
