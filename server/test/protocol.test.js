const { PlayerIOMessage, PlayerIOProtocol } = require('../src/PlayerIOProtocol');

function testProtocol() {
  const msg = new PlayerIOMessage('init', [
    'OwnerName', 'World Title', 0, 0, 0, 0, 1, 'PlayerName', 10, 20
  ]);

  const encoded = PlayerIOProtocol.encodeMessage(msg);
  console.log('Encoded buffer length:', encoded.length);

  const { messages, remainingBuffer } = PlayerIOProtocol.decodeStream(encoded);
  console.log('Decoded messages count:', messages.length);
  if (messages.length > 0) {
    const decoded = messages[0];
    console.log('Type:', decoded.type);
    console.log('Values:', decoded.values);
    if (decoded.type === 'init' && decoded.getString(0) === 'OwnerName') {
      console.log('TEST PASSED!');
    } else {
      console.error('TEST FAILED: content mismatch');
    }
  } else {
    console.error('TEST FAILED: no messages decoded');
  }
}

testProtocol();
