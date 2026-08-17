/**
 * PlayerIO Binary Protocol Encoder & Decoder for Node.js
 * Compatible with PlayerIO AS3 SDK (Everybody Edits)
 */

const ShortStringPattern       = 0b11000000;
const ShortUnsignedIntPattern = 0b10000000;
const ShortByteArrayPattern   = 0b01000000;
const UnsignedLongPattern     = 0b00111000;
const LongPattern             = 0b00110000;
const ByteArrayPattern        = 0b00010000;
const StringPattern           = 0b00001100;
const UnsignedIntPattern      = 0b00001000;
const IntPattern              = 0b00000100;
const DoublePattern           = 0b00000011;
const FloatPattern            = 0b00000010;
const BooleanTruePattern      = 0b00000001;
const BooleanFalsePattern     = 0b00000000;

class PlayerIOMessage {
  constructor(type = '', values = []) {
    this.type = type;
    this.values = values;
  }

  add(val) {
    this.values.push(val);
  }

  getString(idx) {
    return String(this.values[idx] || '');
  }

  getInt(idx) {
    return parseInt(this.values[idx], 10) || 0;
  }

  getFloat(idx) {
    return parseFloat(this.values[idx]) || 0.0;
  }

  getBoolean(idx) {
    return Boolean(this.values[idx]);
  }

  getByteArray(idx) {
    const val = this.values[idx];
    if (Buffer.isBuffer(val)) return val;
    if (Array.isArray(val)) return Buffer.from(val);
    return Buffer.alloc(0);
  }
}

class PlayerIOProtocol {

  /**
   * Encodes a PlayerIOMessage into a Buffer
   */
  static encodeMessage(msg) {
    const buffers = [];

    // Length header in PlayerIO protocol is values count (msg.values.length)
    const paramCount = msg.values.length;
    buffers.push(this.serializeValue(paramCount));
    buffers.push(this.serializeValue(msg.type));

    for (const val of msg.values) {
      buffers.push(this.serializeValue(val));
    }

    return Buffer.concat(buffers);
  }

  static serializeValue(val) {
    if (val === null || val === undefined) {
      return Buffer.from([BooleanFalsePattern]);
    }

    if (typeof val === 'boolean') {
      return Buffer.from([val ? BooleanTruePattern : BooleanFalsePattern]);
    }

    if (typeof val === 'string') {
      const strBuf = Buffer.from(val, 'utf8');
      if (strBuf.length < 64) {
        const header = Buffer.from([ShortStringPattern | strBuf.length]);
        return Buffer.concat([header, strBuf]);
      } else {
        const lenBuf = this.getUIntBytes(strBuf.length);
        const header = Buffer.from([StringPattern | (lenBuf.length - 1)]);
        return Buffer.concat([header, lenBuf, strBuf]);
      }
    }

    if (Buffer.isBuffer(val)) {
      if (val.length < 64) {
        const header = Buffer.from([ShortByteArrayPattern | val.length]);
        return Buffer.concat([header, val]);
      } else {
        const lenBuf = this.getUIntBytes(val.length);
        const header = Buffer.from([ByteArrayPattern | (lenBuf.length - 1)]);
        return Buffer.concat([header, lenBuf, val]);
      }
    }

    if (typeof val === 'number') {
      if (Number.isInteger(val)) {
        if (val > 0x7FFFFFFF && val <= 0xFFFFFFFF) {
          val = (val | 0);
        }

        if (val >= 0 && val < 64) {
          return Buffer.from([ShortUnsignedIntPattern | val]);
        }

        if (val >= 0) {
          const rawBuf = Buffer.alloc(4);
          rawBuf.writeUInt32BE(val, 0);
          const trimmed = this.trimBuffer(rawBuf);
          const header = Buffer.from([IntPattern | (trimmed.length - 1)]);
          return Buffer.concat([header, trimmed]);
        }

        if (val < 0) {
          const rawBuf = Buffer.alloc(4);
          rawBuf.writeInt32BE(val, 0);
          const header = Buffer.from([IntPattern | 3]);
          return Buffer.concat([header, rawBuf]);
        }
      }

      // Default to Double for non-integer numbers
      const doubleBuf = Buffer.alloc(9);
      doubleBuf[0] = DoublePattern;
      doubleBuf.writeDoubleBE(val, 1);
      return doubleBuf;
    }

    throw new Error(`Unsupported PlayerIO serializable type: ${typeof val}`);
  }

  static getUIntBytes(num) {
    const buf = Buffer.alloc(4);
    buf.writeUInt32BE(num, 0);
    return this.trimBuffer(buf);
  }

  static trimBuffer(buf) {
    let firstNonZero = 0;
    while (firstNonZero < buf.length && buf[firstNonZero] === 0) {
      firstNonZero++;
    }
    if (firstNonZero === buf.length) {
      return Buffer.from([0]);
    }
    return buf.slice(firstNonZero);
  }

  /**
   * Decodes incoming socket stream buffer into PlayerIOMessage instances
   * Returns { messages: PlayerIOMessage[], remainingBuffer: Buffer }
   */
  static decodeStream(streamBuffer) {
    const messages = [];
    let offset = 0;

    while (offset < streamBuffer.length) {
      const startOffset = offset;

      try {
        // Read parameter count
        const countRes = this.readValue(streamBuffer, offset);
        if (!countRes) break; // Incomplete data
        const paramCount = countRes.value;
        offset = countRes.nextOffset;

        // Read message type (string)
        const typeRes = this.readValue(streamBuffer, offset);
        if (!typeRes) {
          offset = startOffset;
          break;
        }
        const msgType = typeRes.value;
        offset = typeRes.nextOffset;

        const values = [];
        let error = false;

        for (let i = 0; i < paramCount; i++) {
          const valRes = this.readValue(streamBuffer, offset);
          if (!valRes) {
            error = true;
            break;
          }
          values.push(valRes.value);
          offset = valRes.nextOffset;
        }

        if (error) {
          offset = startOffset;
          break;
        }

        messages.push(new PlayerIOMessage(msgType, values));
      } catch (err) {
        console.error('Error decoding stream frame:', err);
        offset = startOffset;
        break;
      }
    }

    return {
      messages,
      remainingBuffer: streamBuffer.slice(offset)
    };
  }

  static readValue(buffer, offset) {
    if (offset >= buffer.length) return null;

    const b = buffer[offset];

    // ShortString (0xC0)
    if ((b & 0b11000000) === ShortStringPattern) {
      const len = b & 0b00111111;
      if (offset + 1 + len > buffer.length) return null;
      const str = buffer.toString('utf8', offset + 1, offset + 1 + len);
      return { value: str, nextOffset: offset + 1 + len };
    }

    // ShortUnsignedInt (0x80)
    if ((b & 0b11000000) === ShortUnsignedIntPattern) {
      const val = b & 0b00111111;
      return { value: val, nextOffset: offset + 1 };
    }

    // ShortByteArray (0x40)
    if ((b & 0b11000000) === ShortByteArrayPattern) {
      const len = b & 0b00111111;
      if (offset + 1 + len > buffer.length) return null;
      const data = buffer.slice(offset + 1, offset + 1 + len);
      return { value: data, nextOffset: offset + 1 + len };
    }

    // Boolean
    if (b === BooleanTruePattern) return { value: true, nextOffset: offset + 1 };
    if (b === BooleanFalsePattern) return { value: false, nextOffset: offset + 1 };

    // Float (0x02)
    if (b === FloatPattern) {
      if (offset + 5 > buffer.length) return null;
      const val = buffer.readFloatBE(offset + 1);
      return { value: val, nextOffset: offset + 5 };
    }

    // Double (0x03)
    if (b === DoublePattern) {
      if (offset + 9 > buffer.length) return null;
      const val = buffer.readDoubleBE(offset + 1);
      return { value: val, nextOffset: offset + 9 };
    }

    // Int / UnsignedInt pattern (0x04 / 0x08): low 2 bits specify value byte count - 1
    if ((b & 0b11111100) === IntPattern || (b & 0b11111100) === UnsignedIntPattern) {
      const valBytesCount = (b & 0b00000011) + 1;
      if (offset + 1 + valBytesCount > buffer.length) return null;
      let val = 0;
      for (let i = 0; i < valBytesCount; i++) {
        val = (val * 256) + buffer[offset + 1 + i];
      }
      return { value: val, nextOffset: offset + 1 + valBytesCount };
    }

    // Pattern with length-prefix bytes (StringPattern, ByteArrayPattern)
    const patternType = b & 0b11111100;
    const lenBytesCount = (b & 0b00000011) + 1;

    if (offset + 1 + lenBytesCount > buffer.length) return null;

    let payloadLen = 0;
    for (let i = 0; i < lenBytesCount; i++) {
      payloadLen = (payloadLen << 8) | buffer[offset + 1 + i];
    }

    const payloadOffset = offset + 1 + lenBytesCount;

    if (patternType === StringPattern) {
      if (payloadOffset + payloadLen > buffer.length) return null;
      const str = buffer.toString('utf8', payloadOffset, payloadOffset + payloadLen);
      return { value: str, nextOffset: payloadOffset + payloadLen };
    }

    if (patternType === ByteArrayPattern) {
      if (payloadOffset + payloadLen > buffer.length) return null;
      const data = buffer.slice(payloadOffset, payloadOffset + payloadLen);
      return { value: data, nextOffset: payloadOffset + payloadLen };
    }

    // Default fallback
    return { value: 0, nextOffset: offset + 1 };
  }
}

module.exports = {
  PlayerIOMessage,
  PlayerIOProtocol
};
