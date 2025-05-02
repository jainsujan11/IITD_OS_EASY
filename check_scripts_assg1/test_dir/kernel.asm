
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 78 11 80       	mov    $0x80117850,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 80 76 10 80       	push   $0x80107680
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 a5 43 00 00       	call   80104400 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 76 10 80       	push   $0x80107687
80100097:	50                   	push   %eax
80100098:	e8 33 42 00 00       	call   801042d0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 e7 44 00 00       	call   801045d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 09 44 00 00       	call   80104570 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 41 00 00       	call   80104310 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 8e 76 10 80       	push   $0x8010768e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 ed 41 00 00       	call   801043b0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 9f 76 10 80       	push   $0x8010769f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 41 00 00       	call   801043b0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 5c 41 00 00       	call   80104370 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 b0 43 00 00       	call   801045d0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 ff 42 00 00       	jmp    80104570 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 a6 76 10 80       	push   $0x801076a6
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 2b 43 00 00       	call   801045d0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 9e 3d 00 00       	call   80104070 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 b9 36 00 00       	call   801039a0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 75 42 00 00       	call   80104570 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 1f 42 00 00       	call   80104570 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 52 25 00 00       	call   801028f0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ad 76 10 80       	push   $0x801076ad
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 67 80 10 80 	movl   $0x80108067,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 53 40 00 00       	call   80104420 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 c1 76 10 80       	push   $0x801076c1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 81 5d 00 00       	call   801061a0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 96 5c 00 00       	call   801061a0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 8a 5c 00 00       	call   801061a0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 7e 5c 00 00       	call   801061a0 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 da 41 00 00       	call   80104730 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 25 41 00 00       	call   80104690 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 c5 76 10 80       	push   $0x801076c5
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 20 40 00 00       	call   801045d0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 87 3f 00 00       	call   80104570 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 f0 76 10 80 	movzbl -0x7fef8910(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 e3 3d 00 00       	call   801045d0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf d8 76 10 80       	mov    $0x801076d8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 10 3d 00 00       	call   80104570 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 df 76 10 80       	push   $0x801076df
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 38 3d 00 00       	call   801045d0 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 9b 3b 00 00       	call   80104570 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 fd 37 00 00       	jmp    80104210 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 e7 36 00 00       	call   80104130 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 e8 76 10 80       	push   $0x801076e8
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 8b 39 00 00       	call   80104400 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 df 2e 00 00       	call   801039a0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 94 22 00 00       	call   80102d60 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 bc 22 00 00       	call   80102dd0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 f7 67 00 00       	call   80107330 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 a8 65 00 00       	call   80107150 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 82 64 00 00       	call   80107060 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 90 66 00 00       	call   801072b0 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 7a 21 00 00       	call   80102dd0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 e9 64 00 00       	call   80107150 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 48 67 00 00       	call   801073d0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 b8 3b 00 00       	call   80104890 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 a4 3b 00 00       	call   80104890 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 a3 68 00 00       	call   801075a0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 9a 65 00 00       	call   801072b0 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 38 68 00 00       	call   801075a0 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 aa 3a 00 00       	call   80104850 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 fe 60 00 00       	call   80106ed0 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 d6 64 00 00       	call   801072b0 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 01 77 10 80       	push   $0x80107701
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 0d 77 10 80       	push   $0x8010770d
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 db 35 00 00       	call   80104400 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 8a 37 00 00       	call   801045d0 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ff 10 80       	push   $0x8010ff60
80100e71:	e8 fa 36 00 00       	call   80104570 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ff 10 80       	push   $0x8010ff60
80100e8a:	e8 e1 36 00 00       	call   80104570 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ff 10 80       	push   $0x8010ff60
80100eaf:	e8 1c 37 00 00       	call   801045d0 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ff 10 80       	push   $0x8010ff60
80100ecc:	e8 9f 36 00 00       	call   80104570 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 14 77 10 80       	push   $0x80107714
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 ca 36 00 00       	call   801045d0 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 2f 36 00 00       	call   80104570 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 fd 35 00 00       	jmp    80104570 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 e3 1d 00 00       	call   80102d60 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 39 1e 00 00       	jmp    80102dd0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 82 25 00 00       	call   80103530 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 1c 77 10 80       	push   $0x8010771c
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 3e 26 00 00       	jmp    801036d0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 26 77 10 80       	push   $0x80107726
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 c2 1c 00 00       	call   80102dd0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 2d 1c 00 00       	call   80102d60 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 66 1c 00 00       	call   80102dd0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 2f 77 10 80       	push   $0x8010772f
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 22 24 00 00       	jmp    801035d0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 35 77 10 80       	push   $0x80107735
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 2e 1d 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 3f 77 10 80       	push   $0x8010773f
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 52 77 10 80       	push   $0x80107752
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 3e 1c 00 00       	call   80102f40 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 66 33 00 00       	call   80104690 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 0e 1c 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 09 11 80       	push   $0x80110960
8010136a:	e8 61 32 00 00       	call   801045d0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 09 11 80       	push   $0x80110960
801013d7:	e8 94 31 00 00       	call   80104570 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 66 31 00 00       	call   80104570 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 68 77 10 80       	push   $0x80107768
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 76 1a 00 00       	call   80102f40 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 78 77 10 80       	push   $0x80107778
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 ea 31 00 00       	call   80104730 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 8b 77 10 80       	push   $0x8010778b
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 85 2e 00 00       	call   80104400 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 92 77 10 80       	push   $0x80107792
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 3c 2d 00 00       	call   801042d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 25 11 80       	push   $0x801125b4
801015bc:	e8 6f 31 00 00       	call   80104730 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 25 11 80    	push   0x801125cc
801015cf:	ff 35 c8 25 11 80    	push   0x801125c8
801015d5:	ff 35 c4 25 11 80    	push   0x801125c4
801015db:	ff 35 c0 25 11 80    	push   0x801125c0
801015e1:	ff 35 bc 25 11 80    	push   0x801125bc
801015e7:	ff 35 b8 25 11 80    	push   0x801125b8
801015ed:	ff 35 b4 25 11 80    	push   0x801125b4
801015f3:	68 f8 77 10 80       	push   $0x801077f8
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 fd 2f 00 00       	call   80104690 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 9b 18 00 00       	call   80102f40 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 98 77 10 80       	push   $0x80107798
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 fa 2f 00 00       	call   80104730 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 02 18 00 00       	call   80102f40 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 09 11 80       	push   $0x80110960
8010175f:	e8 6c 2e 00 00       	call   801045d0 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 fc 2d 00 00       	call   80104570 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 69 2b 00 00       	call   80104310 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 13 2f 00 00       	call   80104730 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 b0 77 10 80       	push   $0x801077b0
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 aa 77 10 80       	push   $0x801077aa
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 38 2b 00 00       	call   801043b0 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 dc 2a 00 00       	jmp    80104370 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 bf 77 10 80       	push   $0x801077bf
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 4b 2a 00 00       	call   80104310 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 91 2a 00 00       	call   80104370 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 e5 2c 00 00       	call   801045d0 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 6b 2c 00 00       	jmp    80104570 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 bb 2c 00 00       	call   801045d0 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 4c 2c 00 00       	call   80104570 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 88 29 00 00       	call   801043b0 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 31 29 00 00       	call   80104370 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 bf 77 10 80       	push   $0x801077bf
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 f4 2b 00 00       	call   80104730 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 f8 2a 00 00       	call   80104730 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 00 13 00 00       	call   80102f40 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 cd 2a 00 00       	call   801047a0 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 6e 2a 00 00       	call   801047a0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 d9 77 10 80       	push   $0x801077d9
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 c7 77 10 80       	push   $0x801077c7
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 f1 1b 00 00       	call   801039a0 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 11 28 00 00       	call   801045d0 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 a1 27 00 00       	call   80104570 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 04 29 00 00       	call   80104730 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 1f 25 00 00       	call   801043b0 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 bd 24 00 00       	call   80104370 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 50 28 00 00       	call   80104730 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 80 24 00 00       	call   801043b0 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 21 24 00 00       	call   80104370 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 3e 24 00 00       	call   801043b0 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 1b 24 00 00       	call   801043b0 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 c4 23 00 00       	call   80104370 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 bf 77 10 80       	push   $0x801077bf
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 ae 27 00 00       	call   801047f0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 e8 77 10 80       	push   $0x801077e8
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 02 7e 10 80       	push   $0x80107e02
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 54 78 10 80       	push   $0x80107854
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 4b 78 10 80       	push   $0x8010784b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 66 78 10 80       	push   $0x80107866
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 2b 22 00 00       	call   80104400 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 27 11 80       	mov    0x80112784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 26 11 80       	push   $0x80112600
8010224e:	e8 7d 23 00 00       	call   801045d0 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 7e 1e 00 00       	call   80104130 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 26 11 80       	push   $0x80112600
801022cb:	e8 a0 22 00 00       	call   80104570 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 bd 20 00 00       	call   801043b0 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 26 11 80       	push   $0x80112600
80102328:	e8 a3 22 00 00       	call   801045d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 26 11 80       	push   $0x80112600
80102368:	53                   	push   %ebx
80102369:	e8 02 1d 00 00       	call   80104070 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 e5 21 00 00       	jmp    80104570 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 95 78 10 80       	push   $0x80107895
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 80 78 10 80       	push   $0x80107880
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 6a 78 10 80       	push   $0x8010786a
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 b4 78 10 80       	push   $0x801078b4
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb 50 78 11 80    	cmp    $0x80117850,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 99 21 00 00       	call   80104690 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 78 26 11 80       	mov    0x80112678,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102510:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 40 26 11 80       	push   $0x80112640
80102528:	e8 a3 20 00 00       	call   801045d0 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 28 20 00 00       	jmp    80104570 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 e6 78 10 80       	push   $0x801078e6
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret    
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 ec 78 10 80       	push   $0x801078ec
80102620:	68 40 26 11 80       	push   $0x80112640
80102625:	e8 d6 1d 00 00       	call   80104400 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102680:	a1 74 26 11 80       	mov    0x80112674,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010269a:	c3                   	ret    
8010269b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 40 26 11 80       	push   $0x80112640
801026b3:	e8 18 1f 00 00       	call   801045d0 <acquire>
  r = kmem.freelist;
801026b8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801026bd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 40 26 11 80       	push   $0x80112640
801026e1:	e8 8a 1e 00 00       	call   80104570 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f0:	ba 64 00 00 00       	mov    $0x64,%edx
801026f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026f6:	a8 01                	test   $0x1,%al
801026f8:	0f 84 c2 00 00 00    	je     801027c0 <kbdgetc+0xd0>
{
801026fe:	55                   	push   %ebp
801026ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102704:	89 e5                	mov    %esp,%ebp
80102706:	53                   	push   %ebx
80102707:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102708:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010270e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102711:	3c e0                	cmp    $0xe0,%al
80102713:	74 5b                	je     80102770 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102715:	89 da                	mov    %ebx,%edx
80102717:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010271a:	84 c0                	test   %al,%al
8010271c:	78 62                	js     80102780 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010271e:	85 d2                	test   %edx,%edx
80102720:	74 09                	je     8010272b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102722:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102725:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102728:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010272b:	0f b6 91 20 7a 10 80 	movzbl -0x7fef85e0(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 20 79 10 80 	movzbl -0x7fef86e0(%ecx),%eax
  shift |= shiftcode[data];
80102739:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010273b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010273f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102745:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102748:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274b:	8b 04 85 00 79 10 80 	mov    -0x7fef8700(,%eax,4),%eax
80102752:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102756:	74 0b                	je     80102763 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102758:	8d 50 9f             	lea    -0x61(%eax),%edx
8010275b:	83 fa 19             	cmp    $0x19,%edx
8010275e:	77 48                	ja     801027a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102760:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102766:	c9                   	leave  
80102767:	c3                   	ret    
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
    shift |= E0ESC;
80102770:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102773:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102775:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010277b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 d2                	test   %edx,%edx
80102785:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102788:	0f b6 81 20 7a 10 80 	movzbl -0x7fef85e0(%ecx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 d8                	and    %ebx,%eax
}
80102799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010279c:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
801027a1:	31 c0                	xor    %eax,%eax
}
801027a3:	c9                   	leave  
801027a4:	c3                   	ret    
801027a5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b1:	c9                   	leave  
      c += 'a' - 'A';
801027b2:	83 f9 1a             	cmp    $0x1a,%ecx
801027b5:	0f 42 c2             	cmovb  %edx,%eax
}
801027b8:	c3                   	ret    
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <kbdintr>:

void
kbdintr(void)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027d6:	68 f0 26 10 80       	push   $0x801026f0
801027db:	e8 a0 e0 ff ff       	call   80100880 <consoleintr>
}
801027e0:	83 c4 10             	add    $0x10,%esp
801027e3:	c9                   	leave  
801027e4:	c3                   	ret    
801027e5:	66 90                	xchg   %ax,%ax
801027e7:	66 90                	xchg   %ax,%ax
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	0f 84 cb 00 00 00    	je     801028c8 <lapicinit+0xd8>
  lapic[index] = value;
801027fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102804:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102811:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102817:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010281e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102821:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102824:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102838:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102845:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102848:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010284b:	8b 50 30             	mov    0x30(%eax),%edx
8010284e:	c1 ea 10             	shr    $0x10,%edx
80102851:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102857:	75 77                	jne    801028d0 <lapicinit+0xe0>
  lapic[index] = value;
80102859:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102860:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102866:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102870:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102873:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102880:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102887:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102894:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
801028a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ae:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028b6:	80 e6 10             	and    $0x10,%dh
801028b9:	75 f5                	jne    801028b0 <lapicinit+0xc0>
  lapic[index] = value;
801028bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
}
801028dd:	e9 77 ff ff ff       	jmp    80102859 <lapicinit+0x69>
801028e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 07                	je     80102900 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028f9:	8b 40 20             	mov    0x20(%eax),%eax
801028fc:	c1 e8 18             	shr    $0x18,%eax
801028ff:	c3                   	ret    
    return 0;
80102900:	31 c0                	xor    %eax,%eax
}
80102902:	c3                   	ret    
80102903:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102910 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102910:	a1 80 26 11 80       	mov    0x80112680,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 0d                	je     80102926 <lapiceoi+0x16>
  lapic[index] = value;
80102919:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102920:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102923:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102926:	c3                   	ret    
80102927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292e:	66 90                	xchg   %ax,%ax

80102930 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102930:	c3                   	ret    
80102931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102940:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102941:	b8 0f 00 00 00       	mov    $0xf,%eax
80102946:	ba 70 00 00 00       	mov    $0x70,%edx
8010294b:	89 e5                	mov    %esp,%ebp
8010294d:	53                   	push   %ebx
8010294e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102951:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102954:	ee                   	out    %al,(%dx)
80102955:	b8 0a 00 00 00       	mov    $0xa,%eax
8010295a:	ba 71 00 00 00       	mov    $0x71,%edx
8010295f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102960:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102962:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102965:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010296b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010296d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102970:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102972:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102975:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102978:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010297e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102983:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102989:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102993:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102996:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102999:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029cd:	c9                   	leave  
801029ce:	c3                   	ret    
801029cf:	90                   	nop

801029d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029d0:	55                   	push   %ebp
801029d1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	57                   	push   %edi
801029de:	56                   	push   %esi
801029df:	53                   	push   %ebx
801029e0:	83 ec 4c             	sub    $0x4c,%esp
801029e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e4:	ba 71 00 00 00       	mov    $0x71,%edx
801029e9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ed:	bb 70 00 00 00       	mov    $0x70,%ebx
801029f2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029f5:	8d 76 00             	lea    0x0(%esi),%esi
801029f8:	31 c0                	xor    %eax,%eax
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a08:	89 da                	mov    %ebx,%edx
80102a0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a16:	89 da                	mov    %ebx,%edx
80102a18:	b8 04 00 00 00       	mov    $0x4,%eax
80102a1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1e:	89 ca                	mov    %ecx,%edx
80102a20:	ec                   	in     (%dx),%al
80102a21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 07 00 00 00       	mov    $0x7,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al
80102a2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a32:	89 da                	mov    %ebx,%edx
80102a34:	b8 08 00 00 00       	mov    $0x8,%eax
80102a39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3a:	89 ca                	mov    %ecx,%edx
80102a3c:	ec                   	in     (%dx),%al
80102a3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3f:	89 da                	mov    %ebx,%edx
80102a41:	b8 09 00 00 00       	mov    $0x9,%eax
80102a46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a57:	84 c0                	test   %al,%al
80102a59:	78 9d                	js     801029f8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a5f:	89 fa                	mov    %edi,%edx
80102a61:	0f b6 fa             	movzbl %dl,%edi
80102a64:	89 f2                	mov    %esi,%edx
80102a66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a6d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a70:	89 da                	mov    %ebx,%edx
80102a72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a89:	31 c0                	xor    %eax,%eax
80102a8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a97:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9d:	89 ca                	mov    %ecx,%edx
80102a9f:	ec                   	in     (%dx),%al
80102aa0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa3:	89 da                	mov    %ebx,%edx
80102aa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	89 da                	mov    %ebx,%edx
80102ab6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ab9:	b8 07 00 00 00       	mov    $0x7,%eax
80102abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abf:	89 ca                	mov    %ecx,%edx
80102ac1:	ec                   	in     (%dx),%al
80102ac2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac5:	89 da                	mov    %ebx,%edx
80102ac7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aca:	b8 08 00 00 00       	mov    $0x8,%eax
80102acf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
80102ad3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad6:	89 da                	mov    %ebx,%edx
80102ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102adb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae1:	89 ca                	mov    %ecx,%edx
80102ae3:	ec                   	in     (%dx),%al
80102ae4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ae7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102af0:	6a 18                	push   $0x18
80102af2:	50                   	push   %eax
80102af3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102af6:	50                   	push   %eax
80102af7:	e8 e4 1b 00 00       	call   801046e0 <memcmp>
80102afc:	83 c4 10             	add    $0x10,%esp
80102aff:	85 c0                	test   %eax,%eax
80102b01:	0f 85 f1 fe ff ff    	jne    801029f8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b0b:	75 78                	jne    80102b85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b85:	8b 75 08             	mov    0x8(%ebp),%esi
80102b88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b8b:	89 06                	mov    %eax,(%esi)
80102b8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b90:	89 46 04             	mov    %eax,0x4(%esi)
80102b93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b96:	89 46 08             	mov    %eax,0x8(%esi)
80102b99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ba2:	89 46 10             	mov    %eax,0x10(%esi)
80102ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bb5:	5b                   	pop    %ebx
80102bb6:	5e                   	pop    %esi
80102bb7:	5f                   	pop    %edi
80102bb8:	5d                   	pop    %ebp
80102bb9:	c3                   	ret    
80102bba:	66 90                	xchg   %ax,%ax
80102bbc:	66 90                	xchg   %ax,%ax
80102bbe:	66 90                	xchg   %ax,%ax

80102bc0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bc0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102bc6:	85 c9                	test   %ecx,%ecx
80102bc8:	0f 8e 8a 00 00 00    	jle    80102c58 <install_trans+0x98>
{
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd2:	31 ff                	xor    %edi,%edi
{
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102be0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 e4 26 11 80    	push   0x801126e4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c04:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0d:	e8 be d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c17:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1a:	68 00 02 00 00       	push   $0x200
80102c1f:	50                   	push   %eax
80102c20:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c23:	50                   	push   %eax
80102c24:	e8 07 1b 00 00       	call   80104730 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c29:	89 1c 24             	mov    %ebx,(%esp)
80102c2c:	e8 7f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c31:	89 34 24             	mov    %esi,(%esp)
80102c34:	e8 b7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 af d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c4a:	7f 94                	jg     80102be0 <install_trans+0x20>
  }
}
80102c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c4f:	5b                   	pop    %ebx
80102c50:	5e                   	pop    %esi
80102c51:	5f                   	pop    %edi
80102c52:	5d                   	pop    %ebp
80102c53:	c3                   	ret    
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c58:	c3                   	ret    
80102c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	53                   	push   %ebx
80102c64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c67:	ff 35 d4 26 11 80    	push   0x801126d4
80102c6d:	ff 35 e4 26 11 80    	push   0x801126e4
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c7d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c90:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102c97:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c9b:	83 c2 01             	add    $0x1,%edx
80102c9e:	39 d0                	cmp    %edx,%eax
80102ca0:	75 ee                	jne    80102c90 <write_head+0x30>
  }
  bwrite(buf);
80102ca2:	83 ec 0c             	sub    $0xc,%esp
80102ca5:	53                   	push   %ebx
80102ca6:	e8 05 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cab:	89 1c 24             	mov    %ebx,(%esp)
80102cae:	e8 3d d5 ff ff       	call   801001f0 <brelse>
}
80102cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb6:	83 c4 10             	add    $0x10,%esp
80102cb9:	c9                   	leave  
80102cba:	c3                   	ret    
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop

80102cc0 <initlog>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 2c             	sub    $0x2c,%esp
80102cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cca:	68 20 7b 10 80       	push   $0x80107b20
80102ccf:	68 a0 26 11 80       	push   $0x801126a0
80102cd4:	e8 27 17 00 00       	call   80104400 <initlock>
  readsb(dev, &sb);
80102cd9:	58                   	pop    %eax
80102cda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 3b e8 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ce8:	59                   	pop    %ecx
  log.dev = dev;
80102ce9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102cef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf2:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102cf7:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 cb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d05:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d08:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d0b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102d11:	85 db                	test   %ebx,%ebx
80102d13:	7e 1d                	jle    80102d32 <initlog+0x72>
80102d15:	31 d2                	xor    %edx,%edx
80102d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d20:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d24:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d3                	cmp    %edx,%ebx
80102d30:	75 ee                	jne    80102d20 <initlog+0x60>
  brelse(buf);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	50                   	push   %eax
80102d36:	e8 b5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d3b:	e8 80 fe ff ff       	call   80102bc0 <install_trans>
  log.lh.n = 0;
80102d40:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d47:	00 00 00 
  write_head(); // clear the log
80102d4a:	e8 11 ff ff ff       	call   80102c60 <write_head>
}
80102d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d52:	83 c4 10             	add    $0x10,%esp
80102d55:	c9                   	leave  
80102d56:	c3                   	ret    
80102d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d66:	68 a0 26 11 80       	push   $0x801126a0
80102d6b:	e8 60 18 00 00       	call   801045d0 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 a0 26 11 80       	push   $0x801126a0
80102d80:	68 a0 26 11 80       	push   $0x801126a0
80102d85:	e8 e6 12 00 00       	call   80104070 <sleep>
80102d8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d8d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 e2                	jne    80102d78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d96:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102d9b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102da1:	83 c0 01             	add    $0x1,%eax
80102da4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102da7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102daa:	83 fa 1e             	cmp    $0x1e,%edx
80102dad:	7f c9                	jg     80102d78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102daf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102db2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102db7:	68 a0 26 11 80       	push   $0x801126a0
80102dbc:	e8 af 17 00 00       	call   80104570 <release>
      break;
    }
  }
}
80102dc1:	83 c4 10             	add    $0x10,%esp
80102dc4:	c9                   	leave  
80102dc5:	c3                   	ret    
80102dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi

80102dd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	57                   	push   %edi
80102dd4:	56                   	push   %esi
80102dd5:	53                   	push   %ebx
80102dd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dd9:	68 a0 26 11 80       	push   $0x801126a0
80102dde:	e8 ed 17 00 00       	call   801045d0 <acquire>
  log.outstanding -= 1;
80102de3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102de8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102dee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df4:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102dfa:	85 f6                	test   %esi,%esi
80102dfc:	0f 85 22 01 00 00    	jne    80102f24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e02:	85 db                	test   %ebx,%ebx
80102e04:	0f 85 f6 00 00 00    	jne    80102f00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e0a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e11:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e14:	83 ec 0c             	sub    $0xc,%esp
80102e17:	68 a0 26 11 80       	push   $0x801126a0
80102e1c:	e8 4f 17 00 00       	call   80104570 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e21:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e27:	83 c4 10             	add    $0x10,%esp
80102e2a:	85 c9                	test   %ecx,%ecx
80102e2c:	7f 42                	jg     80102e70 <end_op+0xa0>
    acquire(&log.lock);
80102e2e:	83 ec 0c             	sub    $0xc,%esp
80102e31:	68 a0 26 11 80       	push   $0x801126a0
80102e36:	e8 95 17 00 00       	call   801045d0 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102e42:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 df 12 00 00       	call   80104130 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e58:	e8 13 17 00 00       	call   80104570 <release>
80102e5d:	83 c4 10             	add    $0x10,%esp
}
80102e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e63:	5b                   	pop    %ebx
80102e64:	5e                   	pop    %esi
80102e65:	5f                   	pop    %edi
80102e66:	5d                   	pop    %ebp
80102e67:	c3                   	ret    
80102e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e70:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 e4 26 11 80    	push   0x801126e4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102e94:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9d:	e8 2e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ea2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ea5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ea7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eaa:	68 00 02 00 00       	push   $0x200
80102eaf:	50                   	push   %eax
80102eb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eb3:	50                   	push   %eax
80102eb4:	e8 77 18 00 00       	call   80104730 <memmove>
    bwrite(to);  // write the log
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 ef d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ec1:	89 3c 24             	mov    %edi,(%esp)
80102ec4:	e8 27 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 1f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ee6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102eed:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 34 ff ff ff       	jmp    80102e2e <end_op+0x5e>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 a0 26 11 80       	push   $0x801126a0
80102f08:	e8 23 12 00 00       	call   80104130 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f14:	e8 57 16 00 00       	call   80104570 <release>
80102f19:	83 c4 10             	add    $0x10,%esp
}
80102f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1f:	5b                   	pop    %ebx
80102f20:	5e                   	pop    %esi
80102f21:	5f                   	pop    %edi
80102f22:	5d                   	pop    %ebp
80102f23:	c3                   	ret    
    panic("log.committing");
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 24 7b 10 80       	push   $0x80107b24
80102f2c:	e8 4f d4 ff ff       	call   80100380 <panic>
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop

80102f40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f47:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102f4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f50:	83 fa 1d             	cmp    $0x1d,%edx
80102f53:	0f 8f 85 00 00 00    	jg     80102fde <log_write+0x9e>
80102f59:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102f5e:	83 e8 01             	sub    $0x1,%eax
80102f61:	39 c2                	cmp    %eax,%edx
80102f63:	7d 79                	jge    80102fde <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f65:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	7e 7d                	jle    80102feb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f6e:	83 ec 0c             	sub    $0xc,%esp
80102f71:	68 a0 26 11 80       	push   $0x801126a0
80102f76:	e8 55 16 00 00       	call   801045d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f7b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	85 d2                	test   %edx,%edx
80102f86:	7e 4a                	jle    80102fd2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f88:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	31 c0                	xor    %eax,%eax
80102f8d:	eb 08                	jmp    80102f97 <log_write+0x57>
80102f8f:	90                   	nop
80102f90:	83 c0 01             	add    $0x1,%eax
80102f93:	39 c2                	cmp    %eax,%edx
80102f95:	74 29                	je     80102fc0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f97:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fad:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102fb4:	c9                   	leave  
  release(&log.lock);
80102fb5:	e9 b6 15 00 00       	jmp    80104570 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102fda:	75 cb                	jne    80102fa7 <log_write+0x67>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x87>
    panic("too big a transaction");
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 33 7b 10 80       	push   $0x80107b33
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 49 7b 10 80       	push   $0x80107b49
80102ff3:	e8 88 d3 ff ff       	call   80100380 <panic>
80102ff8:	66 90                	xchg   %ax,%ax
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 74 09 00 00       	call   80103980 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 6d 09 00 00       	call   80103980 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 64 7b 10 80       	push   $0x80107b64
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 a9 2d 00 00       	call   80105dd0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 f4 08 00 00       	call   80103920 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 21 0c 00 00       	call   80103c60 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 75 3e 00 00       	call   80106ec0 <switchkvm>
  seginit();
8010304b:	e8 e0 3d 00 00       	call   80106e30 <seginit>
  lapicinit();
80103050:	e8 9b f7 ff ff       	call   801027f0 <lapicinit>
  mpmain();
80103055:	e8 a6 ff ff ff       	call   80103000 <mpmain>
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103064:	83 e4 f0             	and    $0xfffffff0,%esp
80103067:	ff 71 fc             	push   -0x4(%ecx)
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	53                   	push   %ebx
8010306e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010306f:	83 ec 08             	sub    $0x8,%esp
80103072:	68 00 00 40 80       	push   $0x80400000
80103077:	68 50 78 11 80       	push   $0x80117850
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 2a 43 00 00       	call   801073b0 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 9b 3d 00 00       	call   80106e30 <seginit>
  picinit();       // disable pic
80103095:	e8 76 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 17 30 00 00       	call   801060c0 <uartinit>
  pinit();         // process table
801030a9:	e8 52 08 00 00       	call   80103900 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 9d 2c 00 00       	call   80105d50 <tvinit>
  binit();         // buffer cache
801030b3:	e8 88 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030b8:	e8 53 dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030bd:	e8 fe f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c2:	83 c4 0c             	add    $0xc,%esp
801030c5:	68 8a 00 00 00       	push   $0x8a
801030ca:	68 8c b4 10 80       	push   $0x8010b48c
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 57 16 00 00       	call   80104730 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801030e3:	00 00 00 
801030e6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030eb:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801030f0:	76 7e                	jbe    80103170 <main+0x110>
801030f2:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801030f7:	eb 20                	jmp    80103119 <main+0xb9>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 02 08 00 00       	call   80103920 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103122:	e8 59 f5 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103127:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010313b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 ea f7 ff ff       	call   80102940 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 8e       	push   $0x8e000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 2e f4 ff ff       	call   801025b0 <kinit2>
  userinit();      // first user process
80103182:	e8 49 08 00 00       	call   801039d0 <userinit>
  mpmain();        // finish this processor's setup
80103187:	e8 74 fe ff ff       	call   80103000 <mpmain>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
801031b0:	89 fe                	mov    %edi,%esi
801031b2:	39 fb                	cmp    %edi,%ebx
801031b4:	76 42                	jbe    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 78 7b 10 80       	push   $0x80107b78
801031c3:	56                   	push   %esi
801031c4:	e8 17 15 00 00       	call   801046e0 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f2                	mov    %esi,%edx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031e0:	39 fa                	cmp    %edi,%edx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret    
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
801031fd:	5b                   	pop    %ebx
801031fe:	89 f0                	mov    %esi,%eax
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret    
80103204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop

80103210 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103219:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103220:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103227:	c1 e0 08             	shl    $0x8,%eax
8010322a:	09 d0                	or     %edx,%eax
8010322c:	c1 e0 04             	shl    $0x4,%eax
8010322f:	75 1b                	jne    8010324c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103231:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103238:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010323f:	c1 e0 08             	shl    $0x8,%eax
80103242:	09 d0                	or     %edx,%eax
80103244:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103247:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010324c:	ba 00 04 00 00       	mov    $0x400,%edx
80103251:	e8 3a ff ff ff       	call   80103190 <mpsearch1>
80103256:	89 c3                	mov    %eax,%ebx
80103258:	85 c0                	test   %eax,%eax
8010325a:	0f 84 40 01 00 00    	je     801033a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103260:	8b 73 04             	mov    0x4(%ebx),%esi
80103263:	85 f6                	test   %esi,%esi
80103265:	0f 84 25 01 00 00    	je     80103390 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010326b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010326e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103274:	6a 04                	push   $0x4
80103276:	68 7d 7b 10 80       	push   $0x80107b7d
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 5c 14 00 00       	call   801046e0 <memcmp>
80103284:	83 c4 10             	add    $0x10,%esp
80103287:	85 c0                	test   %eax,%eax
80103289:	0f 85 01 01 00 00    	jne    80103390 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010328f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103296:	3c 01                	cmp    $0x1,%al
80103298:	74 08                	je     801032a2 <mpinit+0x92>
8010329a:	3c 04                	cmp    $0x4,%al
8010329c:	0f 85 ee 00 00 00    	jne    80103390 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032a9:	66 85 d2             	test   %dx,%dx
801032ac:	74 22                	je     801032d0 <mpinit+0xc0>
801032ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032b3:	31 d2                	xor    %edx,%edx
801032b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032c4:	39 c7                	cmp    %eax,%edi
801032c6:	75 f0                	jne    801032b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032c8:	84 d2                	test   %dl,%dl
801032ca:	0f 85 c0 00 00 00    	jne    80103390 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032d6:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032e8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801032f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032f7:	90                   	nop
801032f8:	39 d0                	cmp    %edx,%eax
801032fa:	73 15                	jae    80103311 <mpinit+0x101>
    switch(*p){
801032fc:	0f b6 08             	movzbl (%eax),%ecx
801032ff:	80 f9 02             	cmp    $0x2,%cl
80103302:	74 4c                	je     80103350 <mpinit+0x140>
80103304:	77 3a                	ja     80103340 <mpinit+0x130>
80103306:	84 c9                	test   %cl,%cl
80103308:	74 56                	je     80103360 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010330a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330d:	39 d0                	cmp    %edx,%eax
8010330f:	72 eb                	jb     801032fc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103311:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103314:	85 f6                	test   %esi,%esi
80103316:	0f 84 d9 00 00 00    	je     801033f5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010331c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103320:	74 15                	je     80103337 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103322:	b8 70 00 00 00       	mov    $0x70,%eax
80103327:	ba 22 00 00 00       	mov    $0x22,%edx
8010332c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010332d:	ba 23 00 00 00       	mov    $0x23,%edx
80103332:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103333:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103336:	ee                   	out    %al,(%dx)
  }
}
80103337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333a:	5b                   	pop    %ebx
8010333b:	5e                   	pop    %esi
8010333c:	5f                   	pop    %edi
8010333d:	5d                   	pop    %ebp
8010333e:	c3                   	ret    
8010333f:	90                   	nop
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 c2                	jbe    8010330a <mpinit+0xfa>
80103348:	31 f6                	xor    %esi,%esi
8010334a:	eb ac                	jmp    801032f8 <mpinit+0xe8>
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103350:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103354:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103357:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010335d:	eb 99                	jmp    801032f8 <mpinit+0xe8>
8010335f:	90                   	nop
      if(ncpu < NCPU) {
80103360:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 6c ff ff ff       	jmp    801032f8 <mpinit+0xe8>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 82 7b 10 80       	push   $0x80107b82
80103398:	e8 e3 cf ff ff       	call   80100380 <panic>
8010339d:	8d 76 00             	lea    0x0(%esi),%esi
{
801033a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033a5:	eb 13                	jmp    801033ba <mpinit+0x1aa>
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033b0:	89 f3                	mov    %esi,%ebx
801033b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033b8:	74 d6                	je     80103390 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ba:	83 ec 04             	sub    $0x4,%esp
801033bd:	8d 73 10             	lea    0x10(%ebx),%esi
801033c0:	6a 04                	push   $0x4
801033c2:	68 78 7b 10 80       	push   $0x80107b78
801033c7:	53                   	push   %ebx
801033c8:	e8 13 13 00 00       	call   801046e0 <memcmp>
801033cd:	83 c4 10             	add    $0x10,%esp
801033d0:	85 c0                	test   %eax,%eax
801033d2:	75 dc                	jne    801033b0 <mpinit+0x1a0>
801033d4:	89 da                	mov    %ebx,%edx
801033d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033e8:	39 d6                	cmp    %edx,%esi
801033ea:	75 f4                	jne    801033e0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ec:	84 c0                	test   %al,%al
801033ee:	75 c0                	jne    801033b0 <mpinit+0x1a0>
801033f0:	e9 6b fe ff ff       	jmp    80103260 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033f5:	83 ec 0c             	sub    $0xc,%esp
801033f8:	68 9c 7b 10 80       	push   $0x80107b9c
801033fd:	e8 7e cf ff ff       	call   80100380 <panic>
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <picinit>:
80103410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103415:	ba 21 00 00 00       	mov    $0x21,%edx
8010341a:	ee                   	out    %al,(%dx)
8010341b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103420:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103421:	c3                   	ret    
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 0c             	sub    $0xc,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010343c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010343f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103445:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010344b:	e8 e0 d9 ff ff       	call   80100e30 <filealloc>
80103450:	89 03                	mov    %eax,(%ebx)
80103452:	85 c0                	test   %eax,%eax
80103454:	0f 84 a8 00 00 00    	je     80103502 <pipealloc+0xd2>
8010345a:	e8 d1 d9 ff ff       	call   80100e30 <filealloc>
8010345f:	89 06                	mov    %eax,(%esi)
80103461:	85 c0                	test   %eax,%eax
80103463:	0f 84 87 00 00 00    	je     801034f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103469:	e8 12 f2 ff ff       	call   80102680 <kalloc>
8010346e:	89 c7                	mov    %eax,%edi
80103470:	85 c0                	test   %eax,%eax
80103472:	0f 84 b0 00 00 00    	je     80103528 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103478:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010347f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103482:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103485:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010348c:	00 00 00 
  p->nwrite = 0;
8010348f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103496:	00 00 00 
  p->nread = 0;
80103499:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034a0:	00 00 00 
  initlock(&p->lock, "pipe");
801034a3:	68 bb 7b 10 80       	push   $0x80107bbb
801034a8:	50                   	push   %eax
801034a9:	e8 52 0f 00 00       	call   80104400 <initlock>
  (*f0)->type = FD_PIPE;
801034ae:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034b9:	8b 03                	mov    (%ebx),%eax
801034bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034bf:	8b 03                	mov    (%ebx),%eax
801034c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034c5:	8b 03                	mov    (%ebx),%eax
801034c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034d2:	8b 06                	mov    (%esi),%eax
801034d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034d8:	8b 06                	mov    (%esi),%eax
801034da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034de:	8b 06                	mov    (%esi),%eax
801034e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034e6:	31 c0                	xor    %eax,%eax
}
801034e8:	5b                   	pop    %ebx
801034e9:	5e                   	pop    %esi
801034ea:	5f                   	pop    %edi
801034eb:	5d                   	pop    %ebp
801034ec:	c3                   	ret    
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	74 1e                	je     80103514 <pipealloc+0xe4>
    fileclose(*f0);
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	50                   	push   %eax
801034fa:	e8 f1 d9 ff ff       	call   80100ef0 <fileclose>
801034ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103502:	8b 06                	mov    (%esi),%eax
80103504:	85 c0                	test   %eax,%eax
80103506:	74 0c                	je     80103514 <pipealloc+0xe4>
    fileclose(*f1);
80103508:	83 ec 0c             	sub    $0xc,%esp
8010350b:	50                   	push   %eax
8010350c:	e8 df d9 ff ff       	call   80100ef0 <fileclose>
80103511:	83 c4 10             	add    $0x10,%esp
}
80103514:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010351c:	5b                   	pop    %ebx
8010351d:	5e                   	pop    %esi
8010351e:	5f                   	pop    %edi
8010351f:	5d                   	pop    %ebp
80103520:	c3                   	ret    
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103528:	8b 03                	mov    (%ebx),%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	75 c8                	jne    801034f6 <pipealloc+0xc6>
8010352e:	eb d2                	jmp    80103502 <pipealloc+0xd2>

80103530 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	56                   	push   %esi
80103534:	53                   	push   %ebx
80103535:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103538:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010353b:	83 ec 0c             	sub    $0xc,%esp
8010353e:	53                   	push   %ebx
8010353f:	e8 8c 10 00 00       	call   801045d0 <acquire>
  if(writable){
80103544:	83 c4 10             	add    $0x10,%esp
80103547:	85 f6                	test   %esi,%esi
80103549:	74 65                	je     801035b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103554:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010355b:	00 00 00 
    wakeup(&p->nread);
8010355e:	50                   	push   %eax
8010355f:	e8 cc 0b 00 00       	call   80104130 <wakeup>
80103564:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103567:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010356d:	85 d2                	test   %edx,%edx
8010356f:	75 0a                	jne    8010357b <pipeclose+0x4b>
80103571:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103577:	85 c0                	test   %eax,%eax
80103579:	74 15                	je     80103590 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010357b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010357e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103581:	5b                   	pop    %ebx
80103582:	5e                   	pop    %esi
80103583:	5d                   	pop    %ebp
    release(&p->lock);
80103584:	e9 e7 0f 00 00       	jmp    80104570 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 d7 0f 00 00       	call   80104570 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 16 ef ff ff       	jmp    801024c0 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 67 0b 00 00       	call   80104130 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb 99                	jmp    80103567 <pipeclose+0x37>
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 28             	sub    $0x28,%esp
801035d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035dc:	53                   	push   %ebx
801035dd:	e8 ee 0f 00 00       	call   801045d0 <acquire>
  for(i = 0; i < n; i++){
801035e2:	8b 45 10             	mov    0x10(%ebp),%eax
801035e5:	83 c4 10             	add    $0x10,%esp
801035e8:	85 c0                	test   %eax,%eax
801035ea:	0f 8e c0 00 00 00    	jle    801036b0 <pipewrite+0xe0>
801035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103602:	03 45 10             	add    0x10(%ebp),%eax
80103605:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103608:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103614:	89 ca                	mov    %ecx,%edx
80103616:	05 00 02 00 00       	add    $0x200,%eax
8010361b:	39 c1                	cmp    %eax,%ecx
8010361d:	74 3f                	je     8010365e <pipewrite+0x8e>
8010361f:	eb 67                	jmp    80103688 <pipewrite+0xb8>
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103628:	e8 73 03 00 00       	call   801039a0 <myproc>
8010362d:	8b 48 24             	mov    0x24(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
      wakeup(&p->nread);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 f3 0a 00 00       	call   80104130 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 2a 0a 00 00       	call   80104070 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103646:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010364c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103652:	83 c4 10             	add    $0x10,%esp
80103655:	05 00 02 00 00       	add    $0x200,%eax
8010365a:	39 c2                	cmp    %eax,%edx
8010365c:	75 2a                	jne    80103688 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010365e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	75 c0                	jne    80103628 <pipewrite+0x58>
        release(&p->lock);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	53                   	push   %ebx
8010366c:	e8 ff 0e 00 00       	call   80104570 <release>
        return -1;
80103671:	83 c4 10             	add    $0x10,%esp
80103674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103688:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010368b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010368e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103694:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010369a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010369d:	83 c6 01             	add    $0x1,%esi
801036a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036aa:	0f 85 58 ff ff ff    	jne    80103608 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036b9:	50                   	push   %eax
801036ba:	e8 71 0a 00 00       	call   80104130 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 a9 0e 00 00       	call   80104570 <release>
  return n;
801036c7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	eb aa                	jmp    80103679 <pipewrite+0xa9>
801036cf:	90                   	nop

801036d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 18             	sub    $0x18,%esp
801036d9:	8b 75 08             	mov    0x8(%ebp),%esi
801036dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036df:	56                   	push   %esi
801036e0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036e6:	e8 e5 0e 00 00       	call   801045d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103700:	e8 9b 02 00 00       	call   801039a0 <myproc>
80103705:	8b 48 24             	mov    0x24(%eax),%ecx
80103708:	85 c9                	test   %ecx,%ecx
8010370a:	0f 85 80 00 00 00    	jne    80103790 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103710:	83 ec 08             	sub    $0x8,%esp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	e8 56 09 00 00       	call   80104070 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103720:	83 c4 10             	add    $0x10,%esp
80103723:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103729:	75 0a                	jne    80103735 <piperead+0x65>
8010372b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103731:	85 c0                	test   %eax,%eax
80103733:	75 cb                	jne    80103700 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103735:	8b 55 10             	mov    0x10(%ebp),%edx
80103738:	31 db                	xor    %ebx,%ebx
8010373a:	85 d2                	test   %edx,%edx
8010373c:	7f 20                	jg     8010375e <piperead+0x8e>
8010373e:	eb 2c                	jmp    8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103740:	8d 48 01             	lea    0x1(%eax),%ecx
80103743:	25 ff 01 00 00       	and    $0x1ff,%eax
80103748:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010374e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103753:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103756:	83 c3 01             	add    $0x1,%ebx
80103759:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010375c:	74 0e                	je     8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010375e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103764:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010376a:	75 d4                	jne    80103740 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103775:	50                   	push   %eax
80103776:	e8 b5 09 00 00       	call   80104130 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 ed 0d 00 00       	call   80104570 <release>
  return i;
80103783:	83 c4 10             	add    $0x10,%esp
}
80103786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103789:	89 d8                	mov    %ebx,%eax
8010378b:	5b                   	pop    %ebx
8010378c:	5e                   	pop    %esi
8010378d:	5f                   	pop    %edi
8010378e:	5d                   	pop    %ebp
8010378f:	c3                   	ret    
      release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103793:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103798:	56                   	push   %esi
80103799:	e8 d2 0d 00 00       	call   80104570 <release>
      return -1;
8010379e:	83 c4 10             	add    $0x10,%esp
}
801037a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a4:	89 d8                	mov    %ebx,%eax
801037a6:	5b                   	pop    %ebx
801037a7:	5e                   	pop    %esi
801037a8:	5f                   	pop    %edi
801037a9:	5d                   	pop    %ebp
801037aa:	c3                   	ret    
801037ab:	66 90                	xchg   %ax,%ax
801037ad:	66 90                	xchg   %ax,%ax
801037af:	90                   	nop

801037b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801037b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037bc:	68 20 2d 11 80       	push   $0x80112d20
801037c1:	e8 0a 0e 00 00       	call   801045d0 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 17                	jmp    801037e2 <allocproc+0x32>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
801037d6:	81 fb 54 5f 11 80    	cmp    $0x80115f54,%ebx
801037dc:	0f 84 9e 00 00 00    	je     80103880 <allocproc+0xd0>
    if(p->state == UNUSED)
801037e2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037e5:	85 c0                	test   %eax,%eax
801037e7:	75 e7                	jne    801037d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  // for sending and receiving 
  p->has_msg = 0;
  initlock(&p->msg_lock, "msg_lock");
801037ee:	83 ec 08             	sub    $0x8,%esp
  p->state = EMBRYO;
801037f1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->has_msg = 0;
801037f8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801037ff:	00 00 00 
  p->pid = nextpid++;
80103802:	8d 50 01             	lea    0x1(%eax),%edx
80103805:	89 43 10             	mov    %eax,0x10(%ebx)
  initlock(&p->msg_lock, "msg_lock");
80103808:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
8010380e:	68 c0 7b 10 80       	push   $0x80107bc0
80103813:	50                   	push   %eax
  p->pid = nextpid++;
80103814:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  initlock(&p->msg_lock, "msg_lock");
8010381a:	e8 e1 0b 00 00       	call   80104400 <initlock>
  p->sender = 0;
8010381f:	c7 83 c4 00 00 00 00 	movl   $0x0,0xc4(%ebx)
80103826:	00 00 00 
  release(&ptable.lock);
80103829:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103830:	e8 3b 0d 00 00       	call   80104570 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103835:	e8 46 ee ff ff       	call   80102680 <kalloc>
8010383a:	83 c4 10             	add    $0x10,%esp
8010383d:	89 43 08             	mov    %eax,0x8(%ebx)
80103840:	85 c0                	test   %eax,%eax
80103842:	74 55                	je     80103899 <allocproc+0xe9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103844:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010384a:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010384d:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103852:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103855:	c7 40 14 3e 5d 10 80 	movl   $0x80105d3e,0x14(%eax)
  p->context = (struct context*)sp;
8010385c:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010385f:	6a 14                	push   $0x14
80103861:	6a 00                	push   $0x0
80103863:	50                   	push   %eax
80103864:	e8 27 0e 00 00       	call   80104690 <memset>
  p->context->eip = (uint)forkret;
80103869:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010386c:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010386f:	c7 40 10 b0 38 10 80 	movl   $0x801038b0,0x10(%eax)
}
80103876:	89 d8                	mov    %ebx,%eax
80103878:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010387b:	c9                   	leave  
8010387c:	c3                   	ret    
8010387d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103880:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103883:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103885:	68 20 2d 11 80       	push   $0x80112d20
8010388a:	e8 e1 0c 00 00       	call   80104570 <release>
}
8010388f:	89 d8                	mov    %ebx,%eax
  return 0;
80103891:	83 c4 10             	add    $0x10,%esp
}
80103894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103897:	c9                   	leave  
80103898:	c3                   	ret    
    p->state = UNUSED;
80103899:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038a0:	31 db                	xor    %ebx,%ebx
}
801038a2:	89 d8                	mov    %ebx,%eax
801038a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038a7:	c9                   	leave  
801038a8:	c3                   	ret    
801038a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038b6:	68 20 2d 11 80       	push   $0x80112d20
801038bb:	e8 b0 0c 00 00       	call   80104570 <release>

  if (first) {
801038c0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038c5:	83 c4 10             	add    $0x10,%esp
801038c8:	85 c0                	test   %eax,%eax
801038ca:	75 04                	jne    801038d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038cc:	c9                   	leave  
801038cd:	c3                   	ret    
801038ce:	66 90                	xchg   %ax,%ax
    first = 0;
801038d0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038d7:	00 00 00 
    iinit(ROOTDEV);
801038da:	83 ec 0c             	sub    $0xc,%esp
801038dd:	6a 01                	push   $0x1
801038df:	e8 7c dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
801038e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038eb:	e8 d0 f3 ff ff       	call   80102cc0 <initlog>
}
801038f0:	83 c4 10             	add    $0x10,%esp
801038f3:	c9                   	leave  
801038f4:	c3                   	ret    
801038f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103900 <pinit>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103906:	68 c9 7b 10 80       	push   $0x80107bc9
8010390b:	68 20 2d 11 80       	push   $0x80112d20
80103910:	e8 eb 0a 00 00       	call   80104400 <initlock>
}
80103915:	83 c4 10             	add    $0x10,%esp
80103918:	c9                   	leave  
80103919:	c3                   	ret    
8010391a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103920 <mycpu>:
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	56                   	push   %esi
80103924:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103925:	9c                   	pushf  
80103926:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103927:	f6 c4 02             	test   $0x2,%ah
8010392a:	75 46                	jne    80103972 <mycpu+0x52>
  apicid = lapicid();
8010392c:	e8 bf ef ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103931:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103937:	85 f6                	test   %esi,%esi
80103939:	7e 2a                	jle    80103965 <mycpu+0x45>
8010393b:	31 d2                	xor    %edx,%edx
8010393d:	eb 08                	jmp    80103947 <mycpu+0x27>
8010393f:	90                   	nop
80103940:	83 c2 01             	add    $0x1,%edx
80103943:	39 f2                	cmp    %esi,%edx
80103945:	74 1e                	je     80103965 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103947:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010394d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103954:	39 c3                	cmp    %eax,%ebx
80103956:	75 e8                	jne    80103940 <mycpu+0x20>
}
80103958:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010395b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103961:	5b                   	pop    %ebx
80103962:	5e                   	pop    %esi
80103963:	5d                   	pop    %ebp
80103964:	c3                   	ret    
  panic("unknown apicid\n");
80103965:	83 ec 0c             	sub    $0xc,%esp
80103968:	68 d0 7b 10 80       	push   $0x80107bd0
8010396d:	e8 0e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103972:	83 ec 0c             	sub    $0xc,%esp
80103975:	68 ac 7c 10 80       	push   $0x80107cac
8010397a:	e8 01 ca ff ff       	call   80100380 <panic>
8010397f:	90                   	nop

80103980 <cpuid>:
cpuid() {
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103986:	e8 95 ff ff ff       	call   80103920 <mycpu>
}
8010398b:	c9                   	leave  
  return mycpu()-cpus;
8010398c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103991:	c1 f8 04             	sar    $0x4,%eax
80103994:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010399a:	c3                   	ret    
8010399b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010399f:	90                   	nop

801039a0 <myproc>:
myproc(void) {
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	53                   	push   %ebx
801039a4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039a7:	e8 d4 0a 00 00       	call   80104480 <pushcli>
  c = mycpu();
801039ac:	e8 6f ff ff ff       	call   80103920 <mycpu>
  p = c->proc;
801039b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039b7:	e8 14 0b 00 00       	call   801044d0 <popcli>
}
801039bc:	89 d8                	mov    %ebx,%eax
801039be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039c1:	c9                   	leave  
801039c2:	c3                   	ret    
801039c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039d0 <userinit>:
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	53                   	push   %ebx
801039d4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039d7:	e8 d4 fd ff ff       	call   801037b0 <allocproc>
801039dc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039de:	a3 54 5f 11 80       	mov    %eax,0x80115f54
  if((p->pgdir = setupkvm()) == 0)
801039e3:	e8 48 39 00 00       	call   80107330 <setupkvm>
801039e8:	89 43 04             	mov    %eax,0x4(%ebx)
801039eb:	85 c0                	test   %eax,%eax
801039ed:	0f 84 bd 00 00 00    	je     80103ab0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039f3:	83 ec 04             	sub    $0x4,%esp
801039f6:	68 2c 00 00 00       	push   $0x2c
801039fb:	68 60 b4 10 80       	push   $0x8010b460
80103a00:	50                   	push   %eax
80103a01:	e8 da 35 00 00       	call   80106fe0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a06:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a09:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a0f:	6a 4c                	push   $0x4c
80103a11:	6a 00                	push   $0x0
80103a13:	ff 73 18             	push   0x18(%ebx)
80103a16:	e8 75 0c 00 00       	call   80104690 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a1b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a1e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a23:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a26:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a2b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a32:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a36:	8b 43 18             	mov    0x18(%ebx),%eax
80103a39:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a3d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a41:	8b 43 18             	mov    0x18(%ebx),%eax
80103a44:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a48:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a4c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a4f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a56:	8b 43 18             	mov    0x18(%ebx),%eax
80103a59:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a60:	8b 43 18             	mov    0x18(%ebx),%eax
80103a63:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a6a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a6d:	6a 10                	push   $0x10
80103a6f:	68 f9 7b 10 80       	push   $0x80107bf9
80103a74:	50                   	push   %eax
80103a75:	e8 d6 0d 00 00       	call   80104850 <safestrcpy>
  p->cwd = namei("/");
80103a7a:	c7 04 24 02 7c 10 80 	movl   $0x80107c02,(%esp)
80103a81:	e8 1a e6 ff ff       	call   801020a0 <namei>
80103a86:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a89:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a90:	e8 3b 0b 00 00       	call   801045d0 <acquire>
  p->state = RUNNABLE;
80103a95:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a9c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103aa3:	e8 c8 0a 00 00       	call   80104570 <release>
}
80103aa8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aab:	83 c4 10             	add    $0x10,%esp
80103aae:	c9                   	leave  
80103aaf:	c3                   	ret    
    panic("userinit: out of memory?");
80103ab0:	83 ec 0c             	sub    $0xc,%esp
80103ab3:	68 e0 7b 10 80       	push   $0x80107be0
80103ab8:	e8 c3 c8 ff ff       	call   80100380 <panic>
80103abd:	8d 76 00             	lea    0x0(%esi),%esi

80103ac0 <growproc>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	56                   	push   %esi
80103ac4:	53                   	push   %ebx
80103ac5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ac8:	e8 b3 09 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103acd:	e8 4e fe ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103ad2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ad8:	e8 f3 09 00 00       	call   801044d0 <popcli>
  sz = curproc->sz;
80103add:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103adf:	85 f6                	test   %esi,%esi
80103ae1:	7f 1d                	jg     80103b00 <growproc+0x40>
  } else if(n < 0){
80103ae3:	75 3b                	jne    80103b20 <growproc+0x60>
  switchuvm(curproc);
80103ae5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ae8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103aea:	53                   	push   %ebx
80103aeb:	e8 e0 33 00 00       	call   80106ed0 <switchuvm>
  return 0;
80103af0:	83 c4 10             	add    $0x10,%esp
80103af3:	31 c0                	xor    %eax,%eax
}
80103af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103af8:	5b                   	pop    %ebx
80103af9:	5e                   	pop    %esi
80103afa:	5d                   	pop    %ebp
80103afb:	c3                   	ret    
80103afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b00:	83 ec 04             	sub    $0x4,%esp
80103b03:	01 c6                	add    %eax,%esi
80103b05:	56                   	push   %esi
80103b06:	50                   	push   %eax
80103b07:	ff 73 04             	push   0x4(%ebx)
80103b0a:	e8 41 36 00 00       	call   80107150 <allocuvm>
80103b0f:	83 c4 10             	add    $0x10,%esp
80103b12:	85 c0                	test   %eax,%eax
80103b14:	75 cf                	jne    80103ae5 <growproc+0x25>
      return -1;
80103b16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b1b:	eb d8                	jmp    80103af5 <growproc+0x35>
80103b1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b20:	83 ec 04             	sub    $0x4,%esp
80103b23:	01 c6                	add    %eax,%esi
80103b25:	56                   	push   %esi
80103b26:	50                   	push   %eax
80103b27:	ff 73 04             	push   0x4(%ebx)
80103b2a:	e8 51 37 00 00       	call   80107280 <deallocuvm>
80103b2f:	83 c4 10             	add    $0x10,%esp
80103b32:	85 c0                	test   %eax,%eax
80103b34:	75 af                	jne    80103ae5 <growproc+0x25>
80103b36:	eb de                	jmp    80103b16 <growproc+0x56>
80103b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b3f:	90                   	nop

80103b40 <fork>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	57                   	push   %edi
80103b44:	56                   	push   %esi
80103b45:	53                   	push   %ebx
80103b46:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b49:	e8 32 09 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103b4e:	e8 cd fd ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103b53:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b59:	e8 72 09 00 00       	call   801044d0 <popcli>
  if((np = allocproc()) == 0){
80103b5e:	e8 4d fc ff ff       	call   801037b0 <allocproc>
80103b63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b66:	85 c0                	test   %eax,%eax
80103b68:	0f 84 b7 00 00 00    	je     80103c25 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b6e:	83 ec 08             	sub    $0x8,%esp
80103b71:	ff 33                	push   (%ebx)
80103b73:	89 c7                	mov    %eax,%edi
80103b75:	ff 73 04             	push   0x4(%ebx)
80103b78:	e8 a3 38 00 00       	call   80107420 <copyuvm>
80103b7d:	83 c4 10             	add    $0x10,%esp
80103b80:	89 47 04             	mov    %eax,0x4(%edi)
80103b83:	85 c0                	test   %eax,%eax
80103b85:	0f 84 a1 00 00 00    	je     80103c2c <fork+0xec>
  np->sz = curproc->sz;
80103b8b:	8b 03                	mov    (%ebx),%eax
80103b8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b90:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b92:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b95:	89 c8                	mov    %ecx,%eax
80103b97:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b9a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b9f:	8b 73 18             	mov    0x18(%ebx),%esi
80103ba2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103ba4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103ba6:	8b 40 18             	mov    0x18(%eax),%eax
80103ba9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103bb0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bb4:	85 c0                	test   %eax,%eax
80103bb6:	74 13                	je     80103bcb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103bb8:	83 ec 0c             	sub    $0xc,%esp
80103bbb:	50                   	push   %eax
80103bbc:	e8 df d2 ff ff       	call   80100ea0 <filedup>
80103bc1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bc4:	83 c4 10             	add    $0x10,%esp
80103bc7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bcb:	83 c6 01             	add    $0x1,%esi
80103bce:	83 fe 10             	cmp    $0x10,%esi
80103bd1:	75 dd                	jne    80103bb0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103bd3:	83 ec 0c             	sub    $0xc,%esp
80103bd6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bd9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bdc:	e8 6f db ff ff       	call   80101750 <idup>
80103be1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103be4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103be7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bea:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bed:	6a 10                	push   $0x10
80103bef:	53                   	push   %ebx
80103bf0:	50                   	push   %eax
80103bf1:	e8 5a 0c 00 00       	call   80104850 <safestrcpy>
  pid = np->pid;
80103bf6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bf9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c00:	e8 cb 09 00 00       	call   801045d0 <acquire>
  np->state = RUNNABLE;
80103c05:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c0c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c13:	e8 58 09 00 00       	call   80104570 <release>
  return pid;
80103c18:	83 c4 10             	add    $0x10,%esp
}
80103c1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c1e:	89 d8                	mov    %ebx,%eax
80103c20:	5b                   	pop    %ebx
80103c21:	5e                   	pop    %esi
80103c22:	5f                   	pop    %edi
80103c23:	5d                   	pop    %ebp
80103c24:	c3                   	ret    
    return -1;
80103c25:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c2a:	eb ef                	jmp    80103c1b <fork+0xdb>
    kfree(np->kstack);
80103c2c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c2f:	83 ec 0c             	sub    $0xc,%esp
80103c32:	ff 73 08             	push   0x8(%ebx)
80103c35:	e8 86 e8 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103c3a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c41:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c44:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c4b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c50:	eb c9                	jmp    80103c1b <fork+0xdb>
80103c52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c60 <scheduler>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	57                   	push   %edi
80103c64:	56                   	push   %esi
80103c65:	53                   	push   %ebx
80103c66:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c69:	e8 b2 fc ff ff       	call   80103920 <mycpu>
  c->proc = 0;
80103c6e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c75:	00 00 00 
  struct cpu *c = mycpu();
80103c78:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c7a:	8d 78 04             	lea    0x4(%eax),%edi
80103c7d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c80:	fb                   	sti    
    acquire(&ptable.lock);
80103c81:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c84:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103c89:	68 20 2d 11 80       	push   $0x80112d20
80103c8e:	e8 3d 09 00 00       	call   801045d0 <acquire>
80103c93:	83 c4 10             	add    $0x10,%esp
80103c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c9d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103ca0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103ca4:	75 33                	jne    80103cd9 <scheduler+0x79>
      switchuvm(p);
80103ca6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103ca9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103caf:	53                   	push   %ebx
80103cb0:	e8 1b 32 00 00       	call   80106ed0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103cb5:	58                   	pop    %eax
80103cb6:	5a                   	pop    %edx
80103cb7:	ff 73 1c             	push   0x1c(%ebx)
80103cba:	57                   	push   %edi
      p->state = RUNNING;
80103cbb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103cc2:	e8 e4 0b 00 00       	call   801048ab <swtch>
      switchkvm();
80103cc7:	e8 f4 31 00 00       	call   80106ec0 <switchkvm>
      c->proc = 0;
80103ccc:	83 c4 10             	add    $0x10,%esp
80103ccf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cd6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cd9:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
80103cdf:	81 fb 54 5f 11 80    	cmp    $0x80115f54,%ebx
80103ce5:	75 b9                	jne    80103ca0 <scheduler+0x40>
    release(&ptable.lock);
80103ce7:	83 ec 0c             	sub    $0xc,%esp
80103cea:	68 20 2d 11 80       	push   $0x80112d20
80103cef:	e8 7c 08 00 00       	call   80104570 <release>
    sti();
80103cf4:	83 c4 10             	add    $0x10,%esp
80103cf7:	eb 87                	jmp    80103c80 <scheduler+0x20>
80103cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d00 <sched>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	56                   	push   %esi
80103d04:	53                   	push   %ebx
  pushcli();
80103d05:	e8 76 07 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103d0a:	e8 11 fc ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103d0f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d15:	e8 b6 07 00 00       	call   801044d0 <popcli>
  if(!holding(&ptable.lock))
80103d1a:	83 ec 0c             	sub    $0xc,%esp
80103d1d:	68 20 2d 11 80       	push   $0x80112d20
80103d22:	e8 09 08 00 00       	call   80104530 <holding>
80103d27:	83 c4 10             	add    $0x10,%esp
80103d2a:	85 c0                	test   %eax,%eax
80103d2c:	74 4f                	je     80103d7d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d2e:	e8 ed fb ff ff       	call   80103920 <mycpu>
80103d33:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d3a:	75 68                	jne    80103da4 <sched+0xa4>
  if(p->state == RUNNING)
80103d3c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d40:	74 55                	je     80103d97 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d42:	9c                   	pushf  
80103d43:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d44:	f6 c4 02             	test   $0x2,%ah
80103d47:	75 41                	jne    80103d8a <sched+0x8a>
  intena = mycpu()->intena;
80103d49:	e8 d2 fb ff ff       	call   80103920 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d4e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d51:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d57:	e8 c4 fb ff ff       	call   80103920 <mycpu>
80103d5c:	83 ec 08             	sub    $0x8,%esp
80103d5f:	ff 70 04             	push   0x4(%eax)
80103d62:	53                   	push   %ebx
80103d63:	e8 43 0b 00 00       	call   801048ab <swtch>
  mycpu()->intena = intena;
80103d68:	e8 b3 fb ff ff       	call   80103920 <mycpu>
}
80103d6d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d70:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d79:	5b                   	pop    %ebx
80103d7a:	5e                   	pop    %esi
80103d7b:	5d                   	pop    %ebp
80103d7c:	c3                   	ret    
    panic("sched ptable.lock");
80103d7d:	83 ec 0c             	sub    $0xc,%esp
80103d80:	68 04 7c 10 80       	push   $0x80107c04
80103d85:	e8 f6 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103d8a:	83 ec 0c             	sub    $0xc,%esp
80103d8d:	68 30 7c 10 80       	push   $0x80107c30
80103d92:	e8 e9 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103d97:	83 ec 0c             	sub    $0xc,%esp
80103d9a:	68 22 7c 10 80       	push   $0x80107c22
80103d9f:	e8 dc c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103da4:	83 ec 0c             	sub    $0xc,%esp
80103da7:	68 16 7c 10 80       	push   $0x80107c16
80103dac:	e8 cf c5 ff ff       	call   80100380 <panic>
80103db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103db8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dbf:	90                   	nop

80103dc0 <exit>:
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	57                   	push   %edi
80103dc4:	56                   	push   %esi
80103dc5:	53                   	push   %ebx
80103dc6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103dc9:	e8 d2 fb ff ff       	call   801039a0 <myproc>
  if(curproc == initproc)
80103dce:	39 05 54 5f 11 80    	cmp    %eax,0x80115f54
80103dd4:	0f 84 07 01 00 00    	je     80103ee1 <exit+0x121>
80103dda:	89 c3                	mov    %eax,%ebx
80103ddc:	8d 70 28             	lea    0x28(%eax),%esi
80103ddf:	8d 78 68             	lea    0x68(%eax),%edi
80103de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103de8:	8b 06                	mov    (%esi),%eax
80103dea:	85 c0                	test   %eax,%eax
80103dec:	74 12                	je     80103e00 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103dee:	83 ec 0c             	sub    $0xc,%esp
80103df1:	50                   	push   %eax
80103df2:	e8 f9 d0 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103df7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103dfd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e00:	83 c6 04             	add    $0x4,%esi
80103e03:	39 f7                	cmp    %esi,%edi
80103e05:	75 e1                	jne    80103de8 <exit+0x28>
  begin_op();
80103e07:	e8 54 ef ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
80103e0c:	83 ec 0c             	sub    $0xc,%esp
80103e0f:	ff 73 68             	push   0x68(%ebx)
80103e12:	e8 99 da ff ff       	call   801018b0 <iput>
  end_op();
80103e17:	e8 b4 ef ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
80103e1c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e23:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e2a:	e8 a1 07 00 00       	call   801045d0 <acquire>
  wakeup1(curproc->parent);
80103e2f:	8b 53 14             	mov    0x14(%ebx),%edx
80103e32:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e35:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e3a:	eb 10                	jmp    80103e4c <exit+0x8c>
80103e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e40:	05 c8 00 00 00       	add    $0xc8,%eax
80103e45:	3d 54 5f 11 80       	cmp    $0x80115f54,%eax
80103e4a:	74 1e                	je     80103e6a <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
80103e4c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e50:	75 ee                	jne    80103e40 <exit+0x80>
80103e52:	3b 50 20             	cmp    0x20(%eax),%edx
80103e55:	75 e9                	jne    80103e40 <exit+0x80>
      p->state = RUNNABLE;
80103e57:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e5e:	05 c8 00 00 00       	add    $0xc8,%eax
80103e63:	3d 54 5f 11 80       	cmp    $0x80115f54,%eax
80103e68:	75 e2                	jne    80103e4c <exit+0x8c>
      p->parent = initproc;
80103e6a:	8b 0d 54 5f 11 80    	mov    0x80115f54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e70:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103e75:	eb 17                	jmp    80103e8e <exit+0xce>
80103e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e7e:	66 90                	xchg   %ax,%ax
80103e80:	81 c2 c8 00 00 00    	add    $0xc8,%edx
80103e86:	81 fa 54 5f 11 80    	cmp    $0x80115f54,%edx
80103e8c:	74 3a                	je     80103ec8 <exit+0x108>
    if(p->parent == curproc){
80103e8e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103e91:	75 ed                	jne    80103e80 <exit+0xc0>
      if(p->state == ZOMBIE)
80103e93:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e97:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e9a:	75 e4                	jne    80103e80 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e9c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ea1:	eb 11                	jmp    80103eb4 <exit+0xf4>
80103ea3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ea7:	90                   	nop
80103ea8:	05 c8 00 00 00       	add    $0xc8,%eax
80103ead:	3d 54 5f 11 80       	cmp    $0x80115f54,%eax
80103eb2:	74 cc                	je     80103e80 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103eb4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103eb8:	75 ee                	jne    80103ea8 <exit+0xe8>
80103eba:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ebd:	75 e9                	jne    80103ea8 <exit+0xe8>
      p->state = RUNNABLE;
80103ebf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103ec6:	eb e0                	jmp    80103ea8 <exit+0xe8>
  curproc->state = ZOMBIE;
80103ec8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103ecf:	e8 2c fe ff ff       	call   80103d00 <sched>
  panic("zombie exit");
80103ed4:	83 ec 0c             	sub    $0xc,%esp
80103ed7:	68 51 7c 10 80       	push   $0x80107c51
80103edc:	e8 9f c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103ee1:	83 ec 0c             	sub    $0xc,%esp
80103ee4:	68 44 7c 10 80       	push   $0x80107c44
80103ee9:	e8 92 c4 ff ff       	call   80100380 <panic>
80103eee:	66 90                	xchg   %ax,%ax

80103ef0 <wait>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	56                   	push   %esi
80103ef4:	53                   	push   %ebx
  pushcli();
80103ef5:	e8 86 05 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103efa:	e8 21 fa ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103eff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f05:	e8 c6 05 00 00       	call   801044d0 <popcli>
  acquire(&ptable.lock);
80103f0a:	83 ec 0c             	sub    $0xc,%esp
80103f0d:	68 20 2d 11 80       	push   $0x80112d20
80103f12:	e8 b9 06 00 00       	call   801045d0 <acquire>
80103f17:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f1a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f1c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f21:	eb 13                	jmp    80103f36 <wait+0x46>
80103f23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f27:	90                   	nop
80103f28:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
80103f2e:	81 fb 54 5f 11 80    	cmp    $0x80115f54,%ebx
80103f34:	74 1e                	je     80103f54 <wait+0x64>
      if(p->parent != curproc)
80103f36:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f39:	75 ed                	jne    80103f28 <wait+0x38>
      if(p->state == ZOMBIE){
80103f3b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f3f:	74 5f                	je     80103fa0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f41:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
      havekids = 1;
80103f47:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f4c:	81 fb 54 5f 11 80    	cmp    $0x80115f54,%ebx
80103f52:	75 e2                	jne    80103f36 <wait+0x46>
    if(!havekids || curproc->killed){
80103f54:	85 c0                	test   %eax,%eax
80103f56:	0f 84 9a 00 00 00    	je     80103ff6 <wait+0x106>
80103f5c:	8b 46 24             	mov    0x24(%esi),%eax
80103f5f:	85 c0                	test   %eax,%eax
80103f61:	0f 85 8f 00 00 00    	jne    80103ff6 <wait+0x106>
  pushcli();
80103f67:	e8 14 05 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103f6c:	e8 af f9 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103f71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f77:	e8 54 05 00 00       	call   801044d0 <popcli>
  if(p == 0)
80103f7c:	85 db                	test   %ebx,%ebx
80103f7e:	0f 84 89 00 00 00    	je     8010400d <wait+0x11d>
  p->chan = chan;
80103f84:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103f87:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f8e:	e8 6d fd ff ff       	call   80103d00 <sched>
  p->chan = 0;
80103f93:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f9a:	e9 7b ff ff ff       	jmp    80103f1a <wait+0x2a>
80103f9f:	90                   	nop
        kfree(p->kstack);
80103fa0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103fa3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fa6:	ff 73 08             	push   0x8(%ebx)
80103fa9:	e8 12 e5 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
80103fae:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fb5:	5a                   	pop    %edx
80103fb6:	ff 73 04             	push   0x4(%ebx)
80103fb9:	e8 f2 32 00 00       	call   801072b0 <freevm>
        p->pid = 0;
80103fbe:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fc5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103fcc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fd0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fd7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fde:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fe5:	e8 86 05 00 00       	call   80104570 <release>
        return pid;
80103fea:	83 c4 10             	add    $0x10,%esp
}
80103fed:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ff0:	89 f0                	mov    %esi,%eax
80103ff2:	5b                   	pop    %ebx
80103ff3:	5e                   	pop    %esi
80103ff4:	5d                   	pop    %ebp
80103ff5:	c3                   	ret    
      release(&ptable.lock);
80103ff6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103ff9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103ffe:	68 20 2d 11 80       	push   $0x80112d20
80104003:	e8 68 05 00 00       	call   80104570 <release>
      return -1;
80104008:	83 c4 10             	add    $0x10,%esp
8010400b:	eb e0                	jmp    80103fed <wait+0xfd>
    panic("sleep");
8010400d:	83 ec 0c             	sub    $0xc,%esp
80104010:	68 5d 7c 10 80       	push   $0x80107c5d
80104015:	e8 66 c3 ff ff       	call   80100380 <panic>
8010401a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104020 <yield>:
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	53                   	push   %ebx
80104024:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104027:	68 20 2d 11 80       	push   $0x80112d20
8010402c:	e8 9f 05 00 00       	call   801045d0 <acquire>
  pushcli();
80104031:	e8 4a 04 00 00       	call   80104480 <pushcli>
  c = mycpu();
80104036:	e8 e5 f8 ff ff       	call   80103920 <mycpu>
  p = c->proc;
8010403b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104041:	e8 8a 04 00 00       	call   801044d0 <popcli>
  myproc()->state = RUNNABLE;
80104046:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010404d:	e8 ae fc ff ff       	call   80103d00 <sched>
  release(&ptable.lock);
80104052:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104059:	e8 12 05 00 00       	call   80104570 <release>
}
8010405e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104061:	83 c4 10             	add    $0x10,%esp
80104064:	c9                   	leave  
80104065:	c3                   	ret    
80104066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010406d:	8d 76 00             	lea    0x0(%esi),%esi

80104070 <sleep>:
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	57                   	push   %edi
80104074:	56                   	push   %esi
80104075:	53                   	push   %ebx
80104076:	83 ec 0c             	sub    $0xc,%esp
80104079:	8b 7d 08             	mov    0x8(%ebp),%edi
8010407c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010407f:	e8 fc 03 00 00       	call   80104480 <pushcli>
  c = mycpu();
80104084:	e8 97 f8 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80104089:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010408f:	e8 3c 04 00 00       	call   801044d0 <popcli>
  if(p == 0)
80104094:	85 db                	test   %ebx,%ebx
80104096:	0f 84 87 00 00 00    	je     80104123 <sleep+0xb3>
  if(lk == 0)
8010409c:	85 f6                	test   %esi,%esi
8010409e:	74 76                	je     80104116 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801040a0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801040a6:	74 50                	je     801040f8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801040a8:	83 ec 0c             	sub    $0xc,%esp
801040ab:	68 20 2d 11 80       	push   $0x80112d20
801040b0:	e8 1b 05 00 00       	call   801045d0 <acquire>
    release(lk);
801040b5:	89 34 24             	mov    %esi,(%esp)
801040b8:	e8 b3 04 00 00       	call   80104570 <release>
  p->chan = chan;
801040bd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040c0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040c7:	e8 34 fc ff ff       	call   80103d00 <sched>
  p->chan = 0;
801040cc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040d3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801040da:	e8 91 04 00 00       	call   80104570 <release>
    acquire(lk);
801040df:	89 75 08             	mov    %esi,0x8(%ebp)
801040e2:	83 c4 10             	add    $0x10,%esp
}
801040e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040e8:	5b                   	pop    %ebx
801040e9:	5e                   	pop    %esi
801040ea:	5f                   	pop    %edi
801040eb:	5d                   	pop    %ebp
    acquire(lk);
801040ec:	e9 df 04 00 00       	jmp    801045d0 <acquire>
801040f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801040f8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040fb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104102:	e8 f9 fb ff ff       	call   80103d00 <sched>
  p->chan = 0;
80104107:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010410e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104111:	5b                   	pop    %ebx
80104112:	5e                   	pop    %esi
80104113:	5f                   	pop    %edi
80104114:	5d                   	pop    %ebp
80104115:	c3                   	ret    
    panic("sleep without lk");
80104116:	83 ec 0c             	sub    $0xc,%esp
80104119:	68 63 7c 10 80       	push   $0x80107c63
8010411e:	e8 5d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
80104123:	83 ec 0c             	sub    $0xc,%esp
80104126:	68 5d 7c 10 80       	push   $0x80107c5d
8010412b:	e8 50 c2 ff ff       	call   80100380 <panic>

80104130 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	83 ec 10             	sub    $0x10,%esp
80104137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010413a:	68 20 2d 11 80       	push   $0x80112d20
8010413f:	e8 8c 04 00 00       	call   801045d0 <acquire>
80104144:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104147:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010414c:	eb 0e                	jmp    8010415c <wakeup+0x2c>
8010414e:	66 90                	xchg   %ax,%ax
80104150:	05 c8 00 00 00       	add    $0xc8,%eax
80104155:	3d 54 5f 11 80       	cmp    $0x80115f54,%eax
8010415a:	74 1e                	je     8010417a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010415c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104160:	75 ee                	jne    80104150 <wakeup+0x20>
80104162:	3b 58 20             	cmp    0x20(%eax),%ebx
80104165:	75 e9                	jne    80104150 <wakeup+0x20>
      p->state = RUNNABLE;
80104167:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010416e:	05 c8 00 00 00       	add    $0xc8,%eax
80104173:	3d 54 5f 11 80       	cmp    $0x80115f54,%eax
80104178:	75 e2                	jne    8010415c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010417a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104181:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104184:	c9                   	leave  
  release(&ptable.lock);
80104185:	e9 e6 03 00 00       	jmp    80104570 <release>
8010418a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104190 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	53                   	push   %ebx
80104194:	83 ec 10             	sub    $0x10,%esp
80104197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010419a:	68 20 2d 11 80       	push   $0x80112d20
8010419f:	e8 2c 04 00 00       	call   801045d0 <acquire>
801041a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041a7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801041ac:	eb 0e                	jmp    801041bc <kill+0x2c>
801041ae:	66 90                	xchg   %ax,%ax
801041b0:	05 c8 00 00 00       	add    $0xc8,%eax
801041b5:	3d 54 5f 11 80       	cmp    $0x80115f54,%eax
801041ba:	74 34                	je     801041f0 <kill+0x60>
    if(p->pid == pid){
801041bc:	39 58 10             	cmp    %ebx,0x10(%eax)
801041bf:	75 ef                	jne    801041b0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041c1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041c5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041cc:	75 07                	jne    801041d5 <kill+0x45>
        p->state = RUNNABLE;
801041ce:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041d5:	83 ec 0c             	sub    $0xc,%esp
801041d8:	68 20 2d 11 80       	push   $0x80112d20
801041dd:	e8 8e 03 00 00       	call   80104570 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041e5:	83 c4 10             	add    $0x10,%esp
801041e8:	31 c0                	xor    %eax,%eax
}
801041ea:	c9                   	leave  
801041eb:	c3                   	ret    
801041ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801041f0:	83 ec 0c             	sub    $0xc,%esp
801041f3:	68 20 2d 11 80       	push   $0x80112d20
801041f8:	e8 73 03 00 00       	call   80104570 <release>
}
801041fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104200:	83 c4 10             	add    $0x10,%esp
80104203:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104208:	c9                   	leave  
80104209:	c3                   	ret    
8010420a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104210 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	57                   	push   %edi
80104214:	56                   	push   %esi
80104215:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104218:	53                   	push   %ebx
80104219:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010421e:	83 ec 3c             	sub    $0x3c,%esp
80104221:	eb 27                	jmp    8010424a <procdump+0x3a>
80104223:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104227:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104228:	83 ec 0c             	sub    $0xc,%esp
8010422b:	68 67 80 10 80       	push   $0x80108067
80104230:	e8 6b c4 ff ff       	call   801006a0 <cprintf>
80104235:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104238:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
8010423e:	81 fb c0 5f 11 80    	cmp    $0x80115fc0,%ebx
80104244:	0f 84 7e 00 00 00    	je     801042c8 <procdump+0xb8>
    if(p->state == UNUSED)
8010424a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010424d:	85 c0                	test   %eax,%eax
8010424f:	74 e7                	je     80104238 <procdump+0x28>
      state = "???";
80104251:	ba 74 7c 10 80       	mov    $0x80107c74,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104256:	83 f8 05             	cmp    $0x5,%eax
80104259:	77 11                	ja     8010426c <procdump+0x5c>
8010425b:	8b 14 85 d4 7c 10 80 	mov    -0x7fef832c(,%eax,4),%edx
      state = "???";
80104262:	b8 74 7c 10 80       	mov    $0x80107c74,%eax
80104267:	85 d2                	test   %edx,%edx
80104269:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010426c:	53                   	push   %ebx
8010426d:	52                   	push   %edx
8010426e:	ff 73 a4             	push   -0x5c(%ebx)
80104271:	68 78 7c 10 80       	push   $0x80107c78
80104276:	e8 25 c4 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
8010427b:	83 c4 10             	add    $0x10,%esp
8010427e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104282:	75 a4                	jne    80104228 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104284:	83 ec 08             	sub    $0x8,%esp
80104287:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010428a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010428d:	50                   	push   %eax
8010428e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104291:	8b 40 0c             	mov    0xc(%eax),%eax
80104294:	83 c0 08             	add    $0x8,%eax
80104297:	50                   	push   %eax
80104298:	e8 83 01 00 00       	call   80104420 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010429d:	83 c4 10             	add    $0x10,%esp
801042a0:	8b 17                	mov    (%edi),%edx
801042a2:	85 d2                	test   %edx,%edx
801042a4:	74 82                	je     80104228 <procdump+0x18>
        cprintf(" %p", pc[i]);
801042a6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801042a9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801042ac:	52                   	push   %edx
801042ad:	68 c1 76 10 80       	push   $0x801076c1
801042b2:	e8 e9 c3 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042b7:	83 c4 10             	add    $0x10,%esp
801042ba:	39 fe                	cmp    %edi,%esi
801042bc:	75 e2                	jne    801042a0 <procdump+0x90>
801042be:	e9 65 ff ff ff       	jmp    80104228 <procdump+0x18>
801042c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042c7:	90                   	nop
  }
}
801042c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042cb:	5b                   	pop    %ebx
801042cc:	5e                   	pop    %esi
801042cd:	5f                   	pop    %edi
801042ce:	5d                   	pop    %ebp
801042cf:	c3                   	ret    

801042d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	53                   	push   %ebx
801042d4:	83 ec 0c             	sub    $0xc,%esp
801042d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042da:	68 ec 7c 10 80       	push   $0x80107cec
801042df:	8d 43 04             	lea    0x4(%ebx),%eax
801042e2:	50                   	push   %eax
801042e3:	e8 18 01 00 00       	call   80104400 <initlock>
  lk->name = name;
801042e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801042eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801042f1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801042f4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801042fb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801042fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104301:	c9                   	leave  
80104302:	c3                   	ret    
80104303:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010430a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104310 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	56                   	push   %esi
80104314:	53                   	push   %ebx
80104315:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104318:	8d 73 04             	lea    0x4(%ebx),%esi
8010431b:	83 ec 0c             	sub    $0xc,%esp
8010431e:	56                   	push   %esi
8010431f:	e8 ac 02 00 00       	call   801045d0 <acquire>
  while (lk->locked) {
80104324:	8b 13                	mov    (%ebx),%edx
80104326:	83 c4 10             	add    $0x10,%esp
80104329:	85 d2                	test   %edx,%edx
8010432b:	74 16                	je     80104343 <acquiresleep+0x33>
8010432d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104330:	83 ec 08             	sub    $0x8,%esp
80104333:	56                   	push   %esi
80104334:	53                   	push   %ebx
80104335:	e8 36 fd ff ff       	call   80104070 <sleep>
  while (lk->locked) {
8010433a:	8b 03                	mov    (%ebx),%eax
8010433c:	83 c4 10             	add    $0x10,%esp
8010433f:	85 c0                	test   %eax,%eax
80104341:	75 ed                	jne    80104330 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104343:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104349:	e8 52 f6 ff ff       	call   801039a0 <myproc>
8010434e:	8b 40 10             	mov    0x10(%eax),%eax
80104351:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104354:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104357:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010435a:	5b                   	pop    %ebx
8010435b:	5e                   	pop    %esi
8010435c:	5d                   	pop    %ebp
  release(&lk->lk);
8010435d:	e9 0e 02 00 00       	jmp    80104570 <release>
80104362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104370 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	56                   	push   %esi
80104374:	53                   	push   %ebx
80104375:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104378:	8d 73 04             	lea    0x4(%ebx),%esi
8010437b:	83 ec 0c             	sub    $0xc,%esp
8010437e:	56                   	push   %esi
8010437f:	e8 4c 02 00 00       	call   801045d0 <acquire>
  lk->locked = 0;
80104384:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010438a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104391:	89 1c 24             	mov    %ebx,(%esp)
80104394:	e8 97 fd ff ff       	call   80104130 <wakeup>
  release(&lk->lk);
80104399:	89 75 08             	mov    %esi,0x8(%ebp)
8010439c:	83 c4 10             	add    $0x10,%esp
}
8010439f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043a2:	5b                   	pop    %ebx
801043a3:	5e                   	pop    %esi
801043a4:	5d                   	pop    %ebp
  release(&lk->lk);
801043a5:	e9 c6 01 00 00       	jmp    80104570 <release>
801043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	57                   	push   %edi
801043b4:	31 ff                	xor    %edi,%edi
801043b6:	56                   	push   %esi
801043b7:	53                   	push   %ebx
801043b8:	83 ec 18             	sub    $0x18,%esp
801043bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801043be:	8d 73 04             	lea    0x4(%ebx),%esi
801043c1:	56                   	push   %esi
801043c2:	e8 09 02 00 00       	call   801045d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801043c7:	8b 03                	mov    (%ebx),%eax
801043c9:	83 c4 10             	add    $0x10,%esp
801043cc:	85 c0                	test   %eax,%eax
801043ce:	75 18                	jne    801043e8 <holdingsleep+0x38>
  release(&lk->lk);
801043d0:	83 ec 0c             	sub    $0xc,%esp
801043d3:	56                   	push   %esi
801043d4:	e8 97 01 00 00       	call   80104570 <release>
  return r;
}
801043d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043dc:	89 f8                	mov    %edi,%eax
801043de:	5b                   	pop    %ebx
801043df:	5e                   	pop    %esi
801043e0:	5f                   	pop    %edi
801043e1:	5d                   	pop    %ebp
801043e2:	c3                   	ret    
801043e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043e7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801043e8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801043eb:	e8 b0 f5 ff ff       	call   801039a0 <myproc>
801043f0:	39 58 10             	cmp    %ebx,0x10(%eax)
801043f3:	0f 94 c0             	sete   %al
801043f6:	0f b6 c0             	movzbl %al,%eax
801043f9:	89 c7                	mov    %eax,%edi
801043fb:	eb d3                	jmp    801043d0 <holdingsleep+0x20>
801043fd:	66 90                	xchg   %ax,%ax
801043ff:	90                   	nop

80104400 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104406:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104409:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010440f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104412:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104419:	5d                   	pop    %ebp
8010441a:	c3                   	ret    
8010441b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010441f:	90                   	nop

80104420 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104420:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104421:	31 d2                	xor    %edx,%edx
{
80104423:	89 e5                	mov    %esp,%ebp
80104425:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104426:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104429:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010442c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010442f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104430:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104436:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010443c:	77 1a                	ja     80104458 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010443e:	8b 58 04             	mov    0x4(%eax),%ebx
80104441:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104444:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104447:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104449:	83 fa 0a             	cmp    $0xa,%edx
8010444c:	75 e2                	jne    80104430 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010444e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104451:	c9                   	leave  
80104452:	c3                   	ret    
80104453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104457:	90                   	nop
  for(; i < 10; i++)
80104458:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010445b:	8d 51 28             	lea    0x28(%ecx),%edx
8010445e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104460:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104466:	83 c0 04             	add    $0x4,%eax
80104469:	39 d0                	cmp    %edx,%eax
8010446b:	75 f3                	jne    80104460 <getcallerpcs+0x40>
}
8010446d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104470:	c9                   	leave  
80104471:	c3                   	ret    
80104472:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104480 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	53                   	push   %ebx
80104484:	83 ec 04             	sub    $0x4,%esp
80104487:	9c                   	pushf  
80104488:	5b                   	pop    %ebx
  asm volatile("cli");
80104489:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010448a:	e8 91 f4 ff ff       	call   80103920 <mycpu>
8010448f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104495:	85 c0                	test   %eax,%eax
80104497:	74 17                	je     801044b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104499:	e8 82 f4 ff ff       	call   80103920 <mycpu>
8010449e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044a8:	c9                   	leave  
801044a9:	c3                   	ret    
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801044b0:	e8 6b f4 ff ff       	call   80103920 <mycpu>
801044b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801044c1:	eb d6                	jmp    80104499 <pushcli+0x19>
801044c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044d0 <popcli>:

void
popcli(void)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044d6:	9c                   	pushf  
801044d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044d8:	f6 c4 02             	test   $0x2,%ah
801044db:	75 35                	jne    80104512 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801044dd:	e8 3e f4 ff ff       	call   80103920 <mycpu>
801044e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801044e9:	78 34                	js     8010451f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044eb:	e8 30 f4 ff ff       	call   80103920 <mycpu>
801044f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801044f6:	85 d2                	test   %edx,%edx
801044f8:	74 06                	je     80104500 <popcli+0x30>
    sti();
}
801044fa:	c9                   	leave  
801044fb:	c3                   	ret    
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104500:	e8 1b f4 ff ff       	call   80103920 <mycpu>
80104505:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010450b:	85 c0                	test   %eax,%eax
8010450d:	74 eb                	je     801044fa <popcli+0x2a>
  asm volatile("sti");
8010450f:	fb                   	sti    
}
80104510:	c9                   	leave  
80104511:	c3                   	ret    
    panic("popcli - interruptible");
80104512:	83 ec 0c             	sub    $0xc,%esp
80104515:	68 f7 7c 10 80       	push   $0x80107cf7
8010451a:	e8 61 be ff ff       	call   80100380 <panic>
    panic("popcli");
8010451f:	83 ec 0c             	sub    $0xc,%esp
80104522:	68 0e 7d 10 80       	push   $0x80107d0e
80104527:	e8 54 be ff ff       	call   80100380 <panic>
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104530 <holding>:
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
80104535:	8b 75 08             	mov    0x8(%ebp),%esi
80104538:	31 db                	xor    %ebx,%ebx
  pushcli();
8010453a:	e8 41 ff ff ff       	call   80104480 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010453f:	8b 06                	mov    (%esi),%eax
80104541:	85 c0                	test   %eax,%eax
80104543:	75 0b                	jne    80104550 <holding+0x20>
  popcli();
80104545:	e8 86 ff ff ff       	call   801044d0 <popcli>
}
8010454a:	89 d8                	mov    %ebx,%eax
8010454c:	5b                   	pop    %ebx
8010454d:	5e                   	pop    %esi
8010454e:	5d                   	pop    %ebp
8010454f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104550:	8b 5e 08             	mov    0x8(%esi),%ebx
80104553:	e8 c8 f3 ff ff       	call   80103920 <mycpu>
80104558:	39 c3                	cmp    %eax,%ebx
8010455a:	0f 94 c3             	sete   %bl
  popcli();
8010455d:	e8 6e ff ff ff       	call   801044d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104562:	0f b6 db             	movzbl %bl,%ebx
}
80104565:	89 d8                	mov    %ebx,%eax
80104567:	5b                   	pop    %ebx
80104568:	5e                   	pop    %esi
80104569:	5d                   	pop    %ebp
8010456a:	c3                   	ret    
8010456b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010456f:	90                   	nop

80104570 <release>:
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	56                   	push   %esi
80104574:	53                   	push   %ebx
80104575:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104578:	e8 03 ff ff ff       	call   80104480 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010457d:	8b 03                	mov    (%ebx),%eax
8010457f:	85 c0                	test   %eax,%eax
80104581:	75 15                	jne    80104598 <release+0x28>
  popcli();
80104583:	e8 48 ff ff ff       	call   801044d0 <popcli>
    panic("release");
80104588:	83 ec 0c             	sub    $0xc,%esp
8010458b:	68 15 7d 10 80       	push   $0x80107d15
80104590:	e8 eb bd ff ff       	call   80100380 <panic>
80104595:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104598:	8b 73 08             	mov    0x8(%ebx),%esi
8010459b:	e8 80 f3 ff ff       	call   80103920 <mycpu>
801045a0:	39 c6                	cmp    %eax,%esi
801045a2:	75 df                	jne    80104583 <release+0x13>
  popcli();
801045a4:	e8 27 ff ff ff       	call   801044d0 <popcli>
  lk->pcs[0] = 0;
801045a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801045b0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801045b7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801045c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045c5:	5b                   	pop    %ebx
801045c6:	5e                   	pop    %esi
801045c7:	5d                   	pop    %ebp
  popcli();
801045c8:	e9 03 ff ff ff       	jmp    801044d0 <popcli>
801045cd:	8d 76 00             	lea    0x0(%esi),%esi

801045d0 <acquire>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801045d7:	e8 a4 fe ff ff       	call   80104480 <pushcli>
  if(holding(lk))
801045dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801045df:	e8 9c fe ff ff       	call   80104480 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045e4:	8b 03                	mov    (%ebx),%eax
801045e6:	85 c0                	test   %eax,%eax
801045e8:	75 7e                	jne    80104668 <acquire+0x98>
  popcli();
801045ea:	e8 e1 fe ff ff       	call   801044d0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801045ef:	b9 01 00 00 00       	mov    $0x1,%ecx
801045f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801045f8:	8b 55 08             	mov    0x8(%ebp),%edx
801045fb:	89 c8                	mov    %ecx,%eax
801045fd:	f0 87 02             	lock xchg %eax,(%edx)
80104600:	85 c0                	test   %eax,%eax
80104602:	75 f4                	jne    801045f8 <acquire+0x28>
  __sync_synchronize();
80104604:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104609:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010460c:	e8 0f f3 ff ff       	call   80103920 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104611:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104614:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104616:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104619:	31 c0                	xor    %eax,%eax
8010461b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010461f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104620:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104626:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010462c:	77 1a                	ja     80104648 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010462e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104631:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104635:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104638:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010463a:	83 f8 0a             	cmp    $0xa,%eax
8010463d:	75 e1                	jne    80104620 <acquire+0x50>
}
8010463f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104642:	c9                   	leave  
80104643:	c3                   	ret    
80104644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104648:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010464c:	8d 51 34             	lea    0x34(%ecx),%edx
8010464f:	90                   	nop
    pcs[i] = 0;
80104650:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104656:	83 c0 04             	add    $0x4,%eax
80104659:	39 c2                	cmp    %eax,%edx
8010465b:	75 f3                	jne    80104650 <acquire+0x80>
}
8010465d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104660:	c9                   	leave  
80104661:	c3                   	ret    
80104662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104668:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010466b:	e8 b0 f2 ff ff       	call   80103920 <mycpu>
80104670:	39 c3                	cmp    %eax,%ebx
80104672:	0f 85 72 ff ff ff    	jne    801045ea <acquire+0x1a>
  popcli();
80104678:	e8 53 fe ff ff       	call   801044d0 <popcli>
    panic("acquire");
8010467d:	83 ec 0c             	sub    $0xc,%esp
80104680:	68 1d 7d 10 80       	push   $0x80107d1d
80104685:	e8 f6 bc ff ff       	call   80100380 <panic>
8010468a:	66 90                	xchg   %ax,%ax
8010468c:	66 90                	xchg   %ax,%ax
8010468e:	66 90                	xchg   %ax,%ax

80104690 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	57                   	push   %edi
80104694:	8b 55 08             	mov    0x8(%ebp),%edx
80104697:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010469a:	53                   	push   %ebx
8010469b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010469e:	89 d7                	mov    %edx,%edi
801046a0:	09 cf                	or     %ecx,%edi
801046a2:	83 e7 03             	and    $0x3,%edi
801046a5:	75 29                	jne    801046d0 <memset+0x40>
    c &= 0xFF;
801046a7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046aa:	c1 e0 18             	shl    $0x18,%eax
801046ad:	89 fb                	mov    %edi,%ebx
801046af:	c1 e9 02             	shr    $0x2,%ecx
801046b2:	c1 e3 10             	shl    $0x10,%ebx
801046b5:	09 d8                	or     %ebx,%eax
801046b7:	09 f8                	or     %edi,%eax
801046b9:	c1 e7 08             	shl    $0x8,%edi
801046bc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801046be:	89 d7                	mov    %edx,%edi
801046c0:	fc                   	cld    
801046c1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801046c3:	5b                   	pop    %ebx
801046c4:	89 d0                	mov    %edx,%eax
801046c6:	5f                   	pop    %edi
801046c7:	5d                   	pop    %ebp
801046c8:	c3                   	ret    
801046c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801046d0:	89 d7                	mov    %edx,%edi
801046d2:	fc                   	cld    
801046d3:	f3 aa                	rep stos %al,%es:(%edi)
801046d5:	5b                   	pop    %ebx
801046d6:	89 d0                	mov    %edx,%eax
801046d8:	5f                   	pop    %edi
801046d9:	5d                   	pop    %ebp
801046da:	c3                   	ret    
801046db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046df:	90                   	nop

801046e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	56                   	push   %esi
801046e4:	8b 75 10             	mov    0x10(%ebp),%esi
801046e7:	8b 55 08             	mov    0x8(%ebp),%edx
801046ea:	53                   	push   %ebx
801046eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046ee:	85 f6                	test   %esi,%esi
801046f0:	74 2e                	je     80104720 <memcmp+0x40>
801046f2:	01 c6                	add    %eax,%esi
801046f4:	eb 14                	jmp    8010470a <memcmp+0x2a>
801046f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104700:	83 c0 01             	add    $0x1,%eax
80104703:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104706:	39 f0                	cmp    %esi,%eax
80104708:	74 16                	je     80104720 <memcmp+0x40>
    if(*s1 != *s2)
8010470a:	0f b6 0a             	movzbl (%edx),%ecx
8010470d:	0f b6 18             	movzbl (%eax),%ebx
80104710:	38 d9                	cmp    %bl,%cl
80104712:	74 ec                	je     80104700 <memcmp+0x20>
      return *s1 - *s2;
80104714:	0f b6 c1             	movzbl %cl,%eax
80104717:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104719:	5b                   	pop    %ebx
8010471a:	5e                   	pop    %esi
8010471b:	5d                   	pop    %ebp
8010471c:	c3                   	ret    
8010471d:	8d 76 00             	lea    0x0(%esi),%esi
80104720:	5b                   	pop    %ebx
  return 0;
80104721:	31 c0                	xor    %eax,%eax
}
80104723:	5e                   	pop    %esi
80104724:	5d                   	pop    %ebp
80104725:	c3                   	ret    
80104726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010472d:	8d 76 00             	lea    0x0(%esi),%esi

80104730 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	57                   	push   %edi
80104734:	8b 55 08             	mov    0x8(%ebp),%edx
80104737:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010473a:	56                   	push   %esi
8010473b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010473e:	39 d6                	cmp    %edx,%esi
80104740:	73 26                	jae    80104768 <memmove+0x38>
80104742:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104745:	39 fa                	cmp    %edi,%edx
80104747:	73 1f                	jae    80104768 <memmove+0x38>
80104749:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010474c:	85 c9                	test   %ecx,%ecx
8010474e:	74 0c                	je     8010475c <memmove+0x2c>
      *--d = *--s;
80104750:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104754:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104757:	83 e8 01             	sub    $0x1,%eax
8010475a:	73 f4                	jae    80104750 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010475c:	5e                   	pop    %esi
8010475d:	89 d0                	mov    %edx,%eax
8010475f:	5f                   	pop    %edi
80104760:	5d                   	pop    %ebp
80104761:	c3                   	ret    
80104762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104768:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010476b:	89 d7                	mov    %edx,%edi
8010476d:	85 c9                	test   %ecx,%ecx
8010476f:	74 eb                	je     8010475c <memmove+0x2c>
80104771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104778:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104779:	39 c6                	cmp    %eax,%esi
8010477b:	75 fb                	jne    80104778 <memmove+0x48>
}
8010477d:	5e                   	pop    %esi
8010477e:	89 d0                	mov    %edx,%eax
80104780:	5f                   	pop    %edi
80104781:	5d                   	pop    %ebp
80104782:	c3                   	ret    
80104783:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010478a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104790 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104790:	eb 9e                	jmp    80104730 <memmove>
80104792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	56                   	push   %esi
801047a4:	8b 75 10             	mov    0x10(%ebp),%esi
801047a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047aa:	53                   	push   %ebx
801047ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801047ae:	85 f6                	test   %esi,%esi
801047b0:	74 2e                	je     801047e0 <strncmp+0x40>
801047b2:	01 d6                	add    %edx,%esi
801047b4:	eb 18                	jmp    801047ce <strncmp+0x2e>
801047b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047bd:	8d 76 00             	lea    0x0(%esi),%esi
801047c0:	38 d8                	cmp    %bl,%al
801047c2:	75 14                	jne    801047d8 <strncmp+0x38>
    n--, p++, q++;
801047c4:	83 c2 01             	add    $0x1,%edx
801047c7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801047ca:	39 f2                	cmp    %esi,%edx
801047cc:	74 12                	je     801047e0 <strncmp+0x40>
801047ce:	0f b6 01             	movzbl (%ecx),%eax
801047d1:	0f b6 1a             	movzbl (%edx),%ebx
801047d4:	84 c0                	test   %al,%al
801047d6:	75 e8                	jne    801047c0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801047d8:	29 d8                	sub    %ebx,%eax
}
801047da:	5b                   	pop    %ebx
801047db:	5e                   	pop    %esi
801047dc:	5d                   	pop    %ebp
801047dd:	c3                   	ret    
801047de:	66 90                	xchg   %ax,%ax
801047e0:	5b                   	pop    %ebx
    return 0;
801047e1:	31 c0                	xor    %eax,%eax
}
801047e3:	5e                   	pop    %esi
801047e4:	5d                   	pop    %ebp
801047e5:	c3                   	ret    
801047e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ed:	8d 76 00             	lea    0x0(%esi),%esi

801047f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	57                   	push   %edi
801047f4:	56                   	push   %esi
801047f5:	8b 75 08             	mov    0x8(%ebp),%esi
801047f8:	53                   	push   %ebx
801047f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801047fc:	89 f0                	mov    %esi,%eax
801047fe:	eb 15                	jmp    80104815 <strncpy+0x25>
80104800:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104804:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104807:	83 c0 01             	add    $0x1,%eax
8010480a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010480e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104811:	84 d2                	test   %dl,%dl
80104813:	74 09                	je     8010481e <strncpy+0x2e>
80104815:	89 cb                	mov    %ecx,%ebx
80104817:	83 e9 01             	sub    $0x1,%ecx
8010481a:	85 db                	test   %ebx,%ebx
8010481c:	7f e2                	jg     80104800 <strncpy+0x10>
    ;
  while(n-- > 0)
8010481e:	89 c2                	mov    %eax,%edx
80104820:	85 c9                	test   %ecx,%ecx
80104822:	7e 17                	jle    8010483b <strncpy+0x4b>
80104824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104828:	83 c2 01             	add    $0x1,%edx
8010482b:	89 c1                	mov    %eax,%ecx
8010482d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104831:	29 d1                	sub    %edx,%ecx
80104833:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104837:	85 c9                	test   %ecx,%ecx
80104839:	7f ed                	jg     80104828 <strncpy+0x38>
  return os;
}
8010483b:	5b                   	pop    %ebx
8010483c:	89 f0                	mov    %esi,%eax
8010483e:	5e                   	pop    %esi
8010483f:	5f                   	pop    %edi
80104840:	5d                   	pop    %ebp
80104841:	c3                   	ret    
80104842:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104850 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	56                   	push   %esi
80104854:	8b 55 10             	mov    0x10(%ebp),%edx
80104857:	8b 75 08             	mov    0x8(%ebp),%esi
8010485a:	53                   	push   %ebx
8010485b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010485e:	85 d2                	test   %edx,%edx
80104860:	7e 25                	jle    80104887 <safestrcpy+0x37>
80104862:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104866:	89 f2                	mov    %esi,%edx
80104868:	eb 16                	jmp    80104880 <safestrcpy+0x30>
8010486a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104870:	0f b6 08             	movzbl (%eax),%ecx
80104873:	83 c0 01             	add    $0x1,%eax
80104876:	83 c2 01             	add    $0x1,%edx
80104879:	88 4a ff             	mov    %cl,-0x1(%edx)
8010487c:	84 c9                	test   %cl,%cl
8010487e:	74 04                	je     80104884 <safestrcpy+0x34>
80104880:	39 d8                	cmp    %ebx,%eax
80104882:	75 ec                	jne    80104870 <safestrcpy+0x20>
    ;
  *s = 0;
80104884:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104887:	89 f0                	mov    %esi,%eax
80104889:	5b                   	pop    %ebx
8010488a:	5e                   	pop    %esi
8010488b:	5d                   	pop    %ebp
8010488c:	c3                   	ret    
8010488d:	8d 76 00             	lea    0x0(%esi),%esi

80104890 <strlen>:

int
strlen(const char *s)
{
80104890:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104891:	31 c0                	xor    %eax,%eax
{
80104893:	89 e5                	mov    %esp,%ebp
80104895:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104898:	80 3a 00             	cmpb   $0x0,(%edx)
8010489b:	74 0c                	je     801048a9 <strlen+0x19>
8010489d:	8d 76 00             	lea    0x0(%esi),%esi
801048a0:	83 c0 01             	add    $0x1,%eax
801048a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048a7:	75 f7                	jne    801048a0 <strlen+0x10>
    ;
  return n;
}
801048a9:	5d                   	pop    %ebp
801048aa:	c3                   	ret    

801048ab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048ab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048af:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801048b3:	55                   	push   %ebp
  pushl %ebx
801048b4:	53                   	push   %ebx
  pushl %esi
801048b5:	56                   	push   %esi
  pushl %edi
801048b6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048b7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048b9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801048bb:	5f                   	pop    %edi
  popl %esi
801048bc:	5e                   	pop    %esi
  popl %ebx
801048bd:	5b                   	pop    %ebx
  popl %ebp
801048be:	5d                   	pop    %ebp
  ret
801048bf:	c3                   	ret    

801048c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	53                   	push   %ebx
801048c4:	83 ec 04             	sub    $0x4,%esp
801048c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801048ca:	e8 d1 f0 ff ff       	call   801039a0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048cf:	8b 00                	mov    (%eax),%eax
801048d1:	39 d8                	cmp    %ebx,%eax
801048d3:	76 1b                	jbe    801048f0 <fetchint+0x30>
801048d5:	8d 53 04             	lea    0x4(%ebx),%edx
801048d8:	39 d0                	cmp    %edx,%eax
801048da:	72 14                	jb     801048f0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801048dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801048df:	8b 13                	mov    (%ebx),%edx
801048e1:	89 10                	mov    %edx,(%eax)
  return 0;
801048e3:	31 c0                	xor    %eax,%eax
}
801048e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048e8:	c9                   	leave  
801048e9:	c3                   	ret    
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801048f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048f5:	eb ee                	jmp    801048e5 <fetchint+0x25>
801048f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fe:	66 90                	xchg   %ax,%ax

80104900 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	53                   	push   %ebx
80104904:	83 ec 04             	sub    $0x4,%esp
80104907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010490a:	e8 91 f0 ff ff       	call   801039a0 <myproc>

  if(addr >= curproc->sz)
8010490f:	39 18                	cmp    %ebx,(%eax)
80104911:	76 2d                	jbe    80104940 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104913:	8b 55 0c             	mov    0xc(%ebp),%edx
80104916:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104918:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010491a:	39 d3                	cmp    %edx,%ebx
8010491c:	73 22                	jae    80104940 <fetchstr+0x40>
8010491e:	89 d8                	mov    %ebx,%eax
80104920:	eb 0d                	jmp    8010492f <fetchstr+0x2f>
80104922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104928:	83 c0 01             	add    $0x1,%eax
8010492b:	39 c2                	cmp    %eax,%edx
8010492d:	76 11                	jbe    80104940 <fetchstr+0x40>
    if(*s == 0)
8010492f:	80 38 00             	cmpb   $0x0,(%eax)
80104932:	75 f4                	jne    80104928 <fetchstr+0x28>
      return s - *pp;
80104934:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104939:	c9                   	leave  
8010493a:	c3                   	ret    
8010493b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010493f:	90                   	nop
80104940:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104943:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104948:	c9                   	leave  
80104949:	c3                   	ret    
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104950 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	56                   	push   %esi
80104954:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104955:	e8 46 f0 ff ff       	call   801039a0 <myproc>
8010495a:	8b 55 08             	mov    0x8(%ebp),%edx
8010495d:	8b 40 18             	mov    0x18(%eax),%eax
80104960:	8b 40 44             	mov    0x44(%eax),%eax
80104963:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104966:	e8 35 f0 ff ff       	call   801039a0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010496b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010496e:	8b 00                	mov    (%eax),%eax
80104970:	39 c6                	cmp    %eax,%esi
80104972:	73 1c                	jae    80104990 <argint+0x40>
80104974:	8d 53 08             	lea    0x8(%ebx),%edx
80104977:	39 d0                	cmp    %edx,%eax
80104979:	72 15                	jb     80104990 <argint+0x40>
  *ip = *(int*)(addr);
8010497b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010497e:	8b 53 04             	mov    0x4(%ebx),%edx
80104981:	89 10                	mov    %edx,(%eax)
  return 0;
80104983:	31 c0                	xor    %eax,%eax
}
80104985:	5b                   	pop    %ebx
80104986:	5e                   	pop    %esi
80104987:	5d                   	pop    %ebp
80104988:	c3                   	ret    
80104989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104995:	eb ee                	jmp    80104985 <argint+0x35>
80104997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499e:	66 90                	xchg   %ax,%ax

801049a0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	57                   	push   %edi
801049a4:	56                   	push   %esi
801049a5:	53                   	push   %ebx
801049a6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801049a9:	e8 f2 ef ff ff       	call   801039a0 <myproc>
801049ae:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049b0:	e8 eb ef ff ff       	call   801039a0 <myproc>
801049b5:	8b 55 08             	mov    0x8(%ebp),%edx
801049b8:	8b 40 18             	mov    0x18(%eax),%eax
801049bb:	8b 40 44             	mov    0x44(%eax),%eax
801049be:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049c1:	e8 da ef ff ff       	call   801039a0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049c6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049c9:	8b 00                	mov    (%eax),%eax
801049cb:	39 c7                	cmp    %eax,%edi
801049cd:	73 31                	jae    80104a00 <argptr+0x60>
801049cf:	8d 4b 08             	lea    0x8(%ebx),%ecx
801049d2:	39 c8                	cmp    %ecx,%eax
801049d4:	72 2a                	jb     80104a00 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801049d6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801049d9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801049dc:	85 d2                	test   %edx,%edx
801049de:	78 20                	js     80104a00 <argptr+0x60>
801049e0:	8b 16                	mov    (%esi),%edx
801049e2:	39 c2                	cmp    %eax,%edx
801049e4:	76 1a                	jbe    80104a00 <argptr+0x60>
801049e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801049e9:	01 c3                	add    %eax,%ebx
801049eb:	39 da                	cmp    %ebx,%edx
801049ed:	72 11                	jb     80104a00 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801049ef:	8b 55 0c             	mov    0xc(%ebp),%edx
801049f2:	89 02                	mov    %eax,(%edx)
  return 0;
801049f4:	31 c0                	xor    %eax,%eax
}
801049f6:	83 c4 0c             	add    $0xc,%esp
801049f9:	5b                   	pop    %ebx
801049fa:	5e                   	pop    %esi
801049fb:	5f                   	pop    %edi
801049fc:	5d                   	pop    %ebp
801049fd:	c3                   	ret    
801049fe:	66 90                	xchg   %ax,%ax
    return -1;
80104a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a05:	eb ef                	jmp    801049f6 <argptr+0x56>
80104a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0e:	66 90                	xchg   %ax,%ax

80104a10 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	56                   	push   %esi
80104a14:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a15:	e8 86 ef ff ff       	call   801039a0 <myproc>
80104a1a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a1d:	8b 40 18             	mov    0x18(%eax),%eax
80104a20:	8b 40 44             	mov    0x44(%eax),%eax
80104a23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a26:	e8 75 ef ff ff       	call   801039a0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a2b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a2e:	8b 00                	mov    (%eax),%eax
80104a30:	39 c6                	cmp    %eax,%esi
80104a32:	73 44                	jae    80104a78 <argstr+0x68>
80104a34:	8d 53 08             	lea    0x8(%ebx),%edx
80104a37:	39 d0                	cmp    %edx,%eax
80104a39:	72 3d                	jb     80104a78 <argstr+0x68>
  *ip = *(int*)(addr);
80104a3b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104a3e:	e8 5d ef ff ff       	call   801039a0 <myproc>
  if(addr >= curproc->sz)
80104a43:	3b 18                	cmp    (%eax),%ebx
80104a45:	73 31                	jae    80104a78 <argstr+0x68>
  *pp = (char*)addr;
80104a47:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a4a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a4c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a4e:	39 d3                	cmp    %edx,%ebx
80104a50:	73 26                	jae    80104a78 <argstr+0x68>
80104a52:	89 d8                	mov    %ebx,%eax
80104a54:	eb 11                	jmp    80104a67 <argstr+0x57>
80104a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a5d:	8d 76 00             	lea    0x0(%esi),%esi
80104a60:	83 c0 01             	add    $0x1,%eax
80104a63:	39 c2                	cmp    %eax,%edx
80104a65:	76 11                	jbe    80104a78 <argstr+0x68>
    if(*s == 0)
80104a67:	80 38 00             	cmpb   $0x0,(%eax)
80104a6a:	75 f4                	jne    80104a60 <argstr+0x50>
      return s - *pp;
80104a6c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104a6e:	5b                   	pop    %ebx
80104a6f:	5e                   	pop    %esi
80104a70:	5d                   	pop    %ebp
80104a71:	c3                   	ret    
80104a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a78:	5b                   	pop    %ebx
    return -1;
80104a79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a7e:	5e                   	pop    %esi
80104a7f:	5d                   	pop    %ebp
80104a80:	c3                   	ret    
80104a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a8f:	90                   	nop

80104a90 <syscall>:



void
syscall(void)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104a97:	e8 04 ef ff ff       	call   801039a0 <myproc>
80104a9c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104a9e:	8b 40 18             	mov    0x18(%eax),%eax
80104aa1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104aa4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104aa7:	83 fa 1d             	cmp    $0x1d,%edx
80104aaa:	77 34                	ja     80104ae0 <syscall+0x50>
80104aac:	8b 14 85 60 7d 10 80 	mov    -0x7fef82a0(,%eax,4),%edx
80104ab3:	85 d2                	test   %edx,%edx
80104ab5:	74 29                	je     80104ae0 <syscall+0x50>
    if(state == 1) 
80104ab7:	83 3d dc 5f 11 80 01 	cmpl   $0x1,0x80115fdc
80104abe:	75 08                	jne    80104ac8 <syscall+0x38>
    	syscall_counts[num]++;
80104ac0:	83 04 85 60 5f 11 80 	addl   $0x1,-0x7feea0a0(,%eax,4)
80104ac7:	01 
    curproc->tf->eax = syscalls[num]();
80104ac8:	ff d2                	call   *%edx
80104aca:	89 c2                	mov    %eax,%edx
80104acc:	8b 43 18             	mov    0x18(%ebx),%eax
80104acf:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ad2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad5:	c9                   	leave  
80104ad6:	c3                   	ret    
80104ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ade:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104ae0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ae1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104ae4:	50                   	push   %eax
80104ae5:	ff 73 10             	push   0x10(%ebx)
80104ae8:	68 25 7d 10 80       	push   $0x80107d25
80104aed:	e8 ae bb ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104af2:	8b 43 18             	mov    0x18(%ebx),%eax
80104af5:	83 c4 10             	add    $0x10,%esp
80104af8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104aff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b02:	c9                   	leave  
80104b03:	c3                   	ret    
80104b04:	66 90                	xchg   %ax,%ax
80104b06:	66 90                	xchg   %ax,%ax
80104b08:	66 90                	xchg   %ax,%ax
80104b0a:	66 90                	xchg   %ax,%ax
80104b0c:	66 90                	xchg   %ax,%ax
80104b0e:	66 90                	xchg   %ax,%ax

80104b10 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	57                   	push   %edi
80104b14:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b15:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104b18:	53                   	push   %ebx
80104b19:	83 ec 34             	sub    $0x34,%esp
80104b1c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104b1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104b22:	57                   	push   %edi
80104b23:	50                   	push   %eax
{
80104b24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b27:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b2a:	e8 91 d5 ff ff       	call   801020c0 <nameiparent>
80104b2f:	83 c4 10             	add    $0x10,%esp
80104b32:	85 c0                	test   %eax,%eax
80104b34:	0f 84 46 01 00 00    	je     80104c80 <create+0x170>
    return 0;
  ilock(dp);
80104b3a:	83 ec 0c             	sub    $0xc,%esp
80104b3d:	89 c3                	mov    %eax,%ebx
80104b3f:	50                   	push   %eax
80104b40:	e8 3b cc ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104b45:	83 c4 0c             	add    $0xc,%esp
80104b48:	6a 00                	push   $0x0
80104b4a:	57                   	push   %edi
80104b4b:	53                   	push   %ebx
80104b4c:	e8 8f d1 ff ff       	call   80101ce0 <dirlookup>
80104b51:	83 c4 10             	add    $0x10,%esp
80104b54:	89 c6                	mov    %eax,%esi
80104b56:	85 c0                	test   %eax,%eax
80104b58:	74 56                	je     80104bb0 <create+0xa0>
    iunlockput(dp);
80104b5a:	83 ec 0c             	sub    $0xc,%esp
80104b5d:	53                   	push   %ebx
80104b5e:	e8 ad ce ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104b63:	89 34 24             	mov    %esi,(%esp)
80104b66:	e8 15 cc ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b6b:	83 c4 10             	add    $0x10,%esp
80104b6e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104b73:	75 1b                	jne    80104b90 <create+0x80>
80104b75:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104b7a:	75 14                	jne    80104b90 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b7f:	89 f0                	mov    %esi,%eax
80104b81:	5b                   	pop    %ebx
80104b82:	5e                   	pop    %esi
80104b83:	5f                   	pop    %edi
80104b84:	5d                   	pop    %ebp
80104b85:	c3                   	ret    
80104b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104b90:	83 ec 0c             	sub    $0xc,%esp
80104b93:	56                   	push   %esi
    return 0;
80104b94:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104b96:	e8 75 ce ff ff       	call   80101a10 <iunlockput>
    return 0;
80104b9b:	83 c4 10             	add    $0x10,%esp
}
80104b9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ba1:	89 f0                	mov    %esi,%eax
80104ba3:	5b                   	pop    %ebx
80104ba4:	5e                   	pop    %esi
80104ba5:	5f                   	pop    %edi
80104ba6:	5d                   	pop    %ebp
80104ba7:	c3                   	ret    
80104ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104baf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104bb0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104bb4:	83 ec 08             	sub    $0x8,%esp
80104bb7:	50                   	push   %eax
80104bb8:	ff 33                	push   (%ebx)
80104bba:	e8 51 ca ff ff       	call   80101610 <ialloc>
80104bbf:	83 c4 10             	add    $0x10,%esp
80104bc2:	89 c6                	mov    %eax,%esi
80104bc4:	85 c0                	test   %eax,%eax
80104bc6:	0f 84 cd 00 00 00    	je     80104c99 <create+0x189>
  ilock(ip);
80104bcc:	83 ec 0c             	sub    $0xc,%esp
80104bcf:	50                   	push   %eax
80104bd0:	e8 ab cb ff ff       	call   80101780 <ilock>
  ip->major = major;
80104bd5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104bd9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104bdd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104be1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104be5:	b8 01 00 00 00       	mov    $0x1,%eax
80104bea:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104bee:	89 34 24             	mov    %esi,(%esp)
80104bf1:	e8 da ca ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104bf6:	83 c4 10             	add    $0x10,%esp
80104bf9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104bfe:	74 30                	je     80104c30 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104c00:	83 ec 04             	sub    $0x4,%esp
80104c03:	ff 76 04             	push   0x4(%esi)
80104c06:	57                   	push   %edi
80104c07:	53                   	push   %ebx
80104c08:	e8 d3 d3 ff ff       	call   80101fe0 <dirlink>
80104c0d:	83 c4 10             	add    $0x10,%esp
80104c10:	85 c0                	test   %eax,%eax
80104c12:	78 78                	js     80104c8c <create+0x17c>
  iunlockput(dp);
80104c14:	83 ec 0c             	sub    $0xc,%esp
80104c17:	53                   	push   %ebx
80104c18:	e8 f3 cd ff ff       	call   80101a10 <iunlockput>
  return ip;
80104c1d:	83 c4 10             	add    $0x10,%esp
}
80104c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c23:	89 f0                	mov    %esi,%eax
80104c25:	5b                   	pop    %ebx
80104c26:	5e                   	pop    %esi
80104c27:	5f                   	pop    %edi
80104c28:	5d                   	pop    %ebp
80104c29:	c3                   	ret    
80104c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104c30:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104c33:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c38:	53                   	push   %ebx
80104c39:	e8 92 ca ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c3e:	83 c4 0c             	add    $0xc,%esp
80104c41:	ff 76 04             	push   0x4(%esi)
80104c44:	68 f8 7d 10 80       	push   $0x80107df8
80104c49:	56                   	push   %esi
80104c4a:	e8 91 d3 ff ff       	call   80101fe0 <dirlink>
80104c4f:	83 c4 10             	add    $0x10,%esp
80104c52:	85 c0                	test   %eax,%eax
80104c54:	78 18                	js     80104c6e <create+0x15e>
80104c56:	83 ec 04             	sub    $0x4,%esp
80104c59:	ff 73 04             	push   0x4(%ebx)
80104c5c:	68 f7 7d 10 80       	push   $0x80107df7
80104c61:	56                   	push   %esi
80104c62:	e8 79 d3 ff ff       	call   80101fe0 <dirlink>
80104c67:	83 c4 10             	add    $0x10,%esp
80104c6a:	85 c0                	test   %eax,%eax
80104c6c:	79 92                	jns    80104c00 <create+0xf0>
      panic("create dots");
80104c6e:	83 ec 0c             	sub    $0xc,%esp
80104c71:	68 eb 7d 10 80       	push   $0x80107deb
80104c76:	e8 05 b7 ff ff       	call   80100380 <panic>
80104c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c7f:	90                   	nop
}
80104c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104c83:	31 f6                	xor    %esi,%esi
}
80104c85:	5b                   	pop    %ebx
80104c86:	89 f0                	mov    %esi,%eax
80104c88:	5e                   	pop    %esi
80104c89:	5f                   	pop    %edi
80104c8a:	5d                   	pop    %ebp
80104c8b:	c3                   	ret    
    panic("create: dirlink");
80104c8c:	83 ec 0c             	sub    $0xc,%esp
80104c8f:	68 fa 7d 10 80       	push   $0x80107dfa
80104c94:	e8 e7 b6 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104c99:	83 ec 0c             	sub    $0xc,%esp
80104c9c:	68 dc 7d 10 80       	push   $0x80107ddc
80104ca1:	e8 da b6 ff ff       	call   80100380 <panic>
80104ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cad:	8d 76 00             	lea    0x0(%esi),%esi

80104cb0 <sys_dup>:
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	56                   	push   %esi
80104cb4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104cb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104cb8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104cbb:	50                   	push   %eax
80104cbc:	6a 00                	push   $0x0
80104cbe:	e8 8d fc ff ff       	call   80104950 <argint>
80104cc3:	83 c4 10             	add    $0x10,%esp
80104cc6:	85 c0                	test   %eax,%eax
80104cc8:	78 36                	js     80104d00 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104cca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104cce:	77 30                	ja     80104d00 <sys_dup+0x50>
80104cd0:	e8 cb ec ff ff       	call   801039a0 <myproc>
80104cd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cd8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104cdc:	85 f6                	test   %esi,%esi
80104cde:	74 20                	je     80104d00 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104ce0:	e8 bb ec ff ff       	call   801039a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ce5:	31 db                	xor    %ebx,%ebx
80104ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104cf0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104cf4:	85 d2                	test   %edx,%edx
80104cf6:	74 18                	je     80104d10 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104cf8:	83 c3 01             	add    $0x1,%ebx
80104cfb:	83 fb 10             	cmp    $0x10,%ebx
80104cfe:	75 f0                	jne    80104cf0 <sys_dup+0x40>
}
80104d00:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d03:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d08:	89 d8                	mov    %ebx,%eax
80104d0a:	5b                   	pop    %ebx
80104d0b:	5e                   	pop    %esi
80104d0c:	5d                   	pop    %ebp
80104d0d:	c3                   	ret    
80104d0e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104d10:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104d13:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d17:	56                   	push   %esi
80104d18:	e8 83 c1 ff ff       	call   80100ea0 <filedup>
  return fd;
80104d1d:	83 c4 10             	add    $0x10,%esp
}
80104d20:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d23:	89 d8                	mov    %ebx,%eax
80104d25:	5b                   	pop    %ebx
80104d26:	5e                   	pop    %esi
80104d27:	5d                   	pop    %ebp
80104d28:	c3                   	ret    
80104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d30 <sys_read>:
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	56                   	push   %esi
80104d34:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d35:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104d38:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d3b:	53                   	push   %ebx
80104d3c:	6a 00                	push   $0x0
80104d3e:	e8 0d fc ff ff       	call   80104950 <argint>
80104d43:	83 c4 10             	add    $0x10,%esp
80104d46:	85 c0                	test   %eax,%eax
80104d48:	78 5e                	js     80104da8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d4e:	77 58                	ja     80104da8 <sys_read+0x78>
80104d50:	e8 4b ec ff ff       	call   801039a0 <myproc>
80104d55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d58:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104d5c:	85 f6                	test   %esi,%esi
80104d5e:	74 48                	je     80104da8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d60:	83 ec 08             	sub    $0x8,%esp
80104d63:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d66:	50                   	push   %eax
80104d67:	6a 02                	push   $0x2
80104d69:	e8 e2 fb ff ff       	call   80104950 <argint>
80104d6e:	83 c4 10             	add    $0x10,%esp
80104d71:	85 c0                	test   %eax,%eax
80104d73:	78 33                	js     80104da8 <sys_read+0x78>
80104d75:	83 ec 04             	sub    $0x4,%esp
80104d78:	ff 75 f0             	push   -0x10(%ebp)
80104d7b:	53                   	push   %ebx
80104d7c:	6a 01                	push   $0x1
80104d7e:	e8 1d fc ff ff       	call   801049a0 <argptr>
80104d83:	83 c4 10             	add    $0x10,%esp
80104d86:	85 c0                	test   %eax,%eax
80104d88:	78 1e                	js     80104da8 <sys_read+0x78>
  return fileread(f, p, n);
80104d8a:	83 ec 04             	sub    $0x4,%esp
80104d8d:	ff 75 f0             	push   -0x10(%ebp)
80104d90:	ff 75 f4             	push   -0xc(%ebp)
80104d93:	56                   	push   %esi
80104d94:	e8 87 c2 ff ff       	call   80101020 <fileread>
80104d99:	83 c4 10             	add    $0x10,%esp
}
80104d9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d9f:	5b                   	pop    %ebx
80104da0:	5e                   	pop    %esi
80104da1:	5d                   	pop    %ebp
80104da2:	c3                   	ret    
80104da3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104da7:	90                   	nop
    return -1;
80104da8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dad:	eb ed                	jmp    80104d9c <sys_read+0x6c>
80104daf:	90                   	nop

80104db0 <sys_write>:
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	56                   	push   %esi
80104db4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104db5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104db8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104dbb:	53                   	push   %ebx
80104dbc:	6a 00                	push   $0x0
80104dbe:	e8 8d fb ff ff       	call   80104950 <argint>
80104dc3:	83 c4 10             	add    $0x10,%esp
80104dc6:	85 c0                	test   %eax,%eax
80104dc8:	78 5e                	js     80104e28 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dce:	77 58                	ja     80104e28 <sys_write+0x78>
80104dd0:	e8 cb eb ff ff       	call   801039a0 <myproc>
80104dd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104dd8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104ddc:	85 f6                	test   %esi,%esi
80104dde:	74 48                	je     80104e28 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104de0:	83 ec 08             	sub    $0x8,%esp
80104de3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104de6:	50                   	push   %eax
80104de7:	6a 02                	push   $0x2
80104de9:	e8 62 fb ff ff       	call   80104950 <argint>
80104dee:	83 c4 10             	add    $0x10,%esp
80104df1:	85 c0                	test   %eax,%eax
80104df3:	78 33                	js     80104e28 <sys_write+0x78>
80104df5:	83 ec 04             	sub    $0x4,%esp
80104df8:	ff 75 f0             	push   -0x10(%ebp)
80104dfb:	53                   	push   %ebx
80104dfc:	6a 01                	push   $0x1
80104dfe:	e8 9d fb ff ff       	call   801049a0 <argptr>
80104e03:	83 c4 10             	add    $0x10,%esp
80104e06:	85 c0                	test   %eax,%eax
80104e08:	78 1e                	js     80104e28 <sys_write+0x78>
  return filewrite(f, p, n);
80104e0a:	83 ec 04             	sub    $0x4,%esp
80104e0d:	ff 75 f0             	push   -0x10(%ebp)
80104e10:	ff 75 f4             	push   -0xc(%ebp)
80104e13:	56                   	push   %esi
80104e14:	e8 97 c2 ff ff       	call   801010b0 <filewrite>
80104e19:	83 c4 10             	add    $0x10,%esp
}
80104e1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e1f:	5b                   	pop    %ebx
80104e20:	5e                   	pop    %esi
80104e21:	5d                   	pop    %ebp
80104e22:	c3                   	ret    
80104e23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e27:	90                   	nop
    return -1;
80104e28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e2d:	eb ed                	jmp    80104e1c <sys_write+0x6c>
80104e2f:	90                   	nop

80104e30 <sys_close>:
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	56                   	push   %esi
80104e34:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e35:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e38:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e3b:	50                   	push   %eax
80104e3c:	6a 00                	push   $0x0
80104e3e:	e8 0d fb ff ff       	call   80104950 <argint>
80104e43:	83 c4 10             	add    $0x10,%esp
80104e46:	85 c0                	test   %eax,%eax
80104e48:	78 3e                	js     80104e88 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e4e:	77 38                	ja     80104e88 <sys_close+0x58>
80104e50:	e8 4b eb ff ff       	call   801039a0 <myproc>
80104e55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e58:	8d 5a 08             	lea    0x8(%edx),%ebx
80104e5b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104e5f:	85 f6                	test   %esi,%esi
80104e61:	74 25                	je     80104e88 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104e63:	e8 38 eb ff ff       	call   801039a0 <myproc>
  fileclose(f);
80104e68:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e6b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104e72:	00 
  fileclose(f);
80104e73:	56                   	push   %esi
80104e74:	e8 77 c0 ff ff       	call   80100ef0 <fileclose>
  return 0;
80104e79:	83 c4 10             	add    $0x10,%esp
80104e7c:	31 c0                	xor    %eax,%eax
}
80104e7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e81:	5b                   	pop    %ebx
80104e82:	5e                   	pop    %esi
80104e83:	5d                   	pop    %ebp
80104e84:	c3                   	ret    
80104e85:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104e88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e8d:	eb ef                	jmp    80104e7e <sys_close+0x4e>
80104e8f:	90                   	nop

80104e90 <sys_fstat>:
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e95:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e98:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e9b:	53                   	push   %ebx
80104e9c:	6a 00                	push   $0x0
80104e9e:	e8 ad fa ff ff       	call   80104950 <argint>
80104ea3:	83 c4 10             	add    $0x10,%esp
80104ea6:	85 c0                	test   %eax,%eax
80104ea8:	78 46                	js     80104ef0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eaa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104eae:	77 40                	ja     80104ef0 <sys_fstat+0x60>
80104eb0:	e8 eb ea ff ff       	call   801039a0 <myproc>
80104eb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104eb8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104ebc:	85 f6                	test   %esi,%esi
80104ebe:	74 30                	je     80104ef0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ec0:	83 ec 04             	sub    $0x4,%esp
80104ec3:	6a 14                	push   $0x14
80104ec5:	53                   	push   %ebx
80104ec6:	6a 01                	push   $0x1
80104ec8:	e8 d3 fa ff ff       	call   801049a0 <argptr>
80104ecd:	83 c4 10             	add    $0x10,%esp
80104ed0:	85 c0                	test   %eax,%eax
80104ed2:	78 1c                	js     80104ef0 <sys_fstat+0x60>
  return filestat(f, st);
80104ed4:	83 ec 08             	sub    $0x8,%esp
80104ed7:	ff 75 f4             	push   -0xc(%ebp)
80104eda:	56                   	push   %esi
80104edb:	e8 f0 c0 ff ff       	call   80100fd0 <filestat>
80104ee0:	83 c4 10             	add    $0x10,%esp
}
80104ee3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ee6:	5b                   	pop    %ebx
80104ee7:	5e                   	pop    %esi
80104ee8:	5d                   	pop    %ebp
80104ee9:	c3                   	ret    
80104eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ef5:	eb ec                	jmp    80104ee3 <sys_fstat+0x53>
80104ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104efe:	66 90                	xchg   %ax,%ax

80104f00 <sys_link>:
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	57                   	push   %edi
80104f04:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f05:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f08:	53                   	push   %ebx
80104f09:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f0c:	50                   	push   %eax
80104f0d:	6a 00                	push   $0x0
80104f0f:	e8 fc fa ff ff       	call   80104a10 <argstr>
80104f14:	83 c4 10             	add    $0x10,%esp
80104f17:	85 c0                	test   %eax,%eax
80104f19:	0f 88 fb 00 00 00    	js     8010501a <sys_link+0x11a>
80104f1f:	83 ec 08             	sub    $0x8,%esp
80104f22:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f25:	50                   	push   %eax
80104f26:	6a 01                	push   $0x1
80104f28:	e8 e3 fa ff ff       	call   80104a10 <argstr>
80104f2d:	83 c4 10             	add    $0x10,%esp
80104f30:	85 c0                	test   %eax,%eax
80104f32:	0f 88 e2 00 00 00    	js     8010501a <sys_link+0x11a>
  begin_op();
80104f38:	e8 23 de ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
80104f3d:	83 ec 0c             	sub    $0xc,%esp
80104f40:	ff 75 d4             	push   -0x2c(%ebp)
80104f43:	e8 58 d1 ff ff       	call   801020a0 <namei>
80104f48:	83 c4 10             	add    $0x10,%esp
80104f4b:	89 c3                	mov    %eax,%ebx
80104f4d:	85 c0                	test   %eax,%eax
80104f4f:	0f 84 e4 00 00 00    	je     80105039 <sys_link+0x139>
  ilock(ip);
80104f55:	83 ec 0c             	sub    $0xc,%esp
80104f58:	50                   	push   %eax
80104f59:	e8 22 c8 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
80104f5e:	83 c4 10             	add    $0x10,%esp
80104f61:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f66:	0f 84 b5 00 00 00    	je     80105021 <sys_link+0x121>
  iupdate(ip);
80104f6c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104f6f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104f74:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f77:	53                   	push   %ebx
80104f78:	e8 53 c7 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
80104f7d:	89 1c 24             	mov    %ebx,(%esp)
80104f80:	e8 db c8 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104f85:	58                   	pop    %eax
80104f86:	5a                   	pop    %edx
80104f87:	57                   	push   %edi
80104f88:	ff 75 d0             	push   -0x30(%ebp)
80104f8b:	e8 30 d1 ff ff       	call   801020c0 <nameiparent>
80104f90:	83 c4 10             	add    $0x10,%esp
80104f93:	89 c6                	mov    %eax,%esi
80104f95:	85 c0                	test   %eax,%eax
80104f97:	74 5b                	je     80104ff4 <sys_link+0xf4>
  ilock(dp);
80104f99:	83 ec 0c             	sub    $0xc,%esp
80104f9c:	50                   	push   %eax
80104f9d:	e8 de c7 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104fa2:	8b 03                	mov    (%ebx),%eax
80104fa4:	83 c4 10             	add    $0x10,%esp
80104fa7:	39 06                	cmp    %eax,(%esi)
80104fa9:	75 3d                	jne    80104fe8 <sys_link+0xe8>
80104fab:	83 ec 04             	sub    $0x4,%esp
80104fae:	ff 73 04             	push   0x4(%ebx)
80104fb1:	57                   	push   %edi
80104fb2:	56                   	push   %esi
80104fb3:	e8 28 d0 ff ff       	call   80101fe0 <dirlink>
80104fb8:	83 c4 10             	add    $0x10,%esp
80104fbb:	85 c0                	test   %eax,%eax
80104fbd:	78 29                	js     80104fe8 <sys_link+0xe8>
  iunlockput(dp);
80104fbf:	83 ec 0c             	sub    $0xc,%esp
80104fc2:	56                   	push   %esi
80104fc3:	e8 48 ca ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80104fc8:	89 1c 24             	mov    %ebx,(%esp)
80104fcb:	e8 e0 c8 ff ff       	call   801018b0 <iput>
  end_op();
80104fd0:	e8 fb dd ff ff       	call   80102dd0 <end_op>
  return 0;
80104fd5:	83 c4 10             	add    $0x10,%esp
80104fd8:	31 c0                	xor    %eax,%eax
}
80104fda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fdd:	5b                   	pop    %ebx
80104fde:	5e                   	pop    %esi
80104fdf:	5f                   	pop    %edi
80104fe0:	5d                   	pop    %ebp
80104fe1:	c3                   	ret    
80104fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104fe8:	83 ec 0c             	sub    $0xc,%esp
80104feb:	56                   	push   %esi
80104fec:	e8 1f ca ff ff       	call   80101a10 <iunlockput>
    goto bad;
80104ff1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104ff4:	83 ec 0c             	sub    $0xc,%esp
80104ff7:	53                   	push   %ebx
80104ff8:	e8 83 c7 ff ff       	call   80101780 <ilock>
  ip->nlink--;
80104ffd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105002:	89 1c 24             	mov    %ebx,(%esp)
80105005:	e8 c6 c6 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
8010500a:	89 1c 24             	mov    %ebx,(%esp)
8010500d:	e8 fe c9 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105012:	e8 b9 dd ff ff       	call   80102dd0 <end_op>
  return -1;
80105017:	83 c4 10             	add    $0x10,%esp
8010501a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010501f:	eb b9                	jmp    80104fda <sys_link+0xda>
    iunlockput(ip);
80105021:	83 ec 0c             	sub    $0xc,%esp
80105024:	53                   	push   %ebx
80105025:	e8 e6 c9 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010502a:	e8 a1 dd ff ff       	call   80102dd0 <end_op>
    return -1;
8010502f:	83 c4 10             	add    $0x10,%esp
80105032:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105037:	eb a1                	jmp    80104fda <sys_link+0xda>
    end_op();
80105039:	e8 92 dd ff ff       	call   80102dd0 <end_op>
    return -1;
8010503e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105043:	eb 95                	jmp    80104fda <sys_link+0xda>
80105045:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010504c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105050 <sys_unlink>:
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	57                   	push   %edi
80105054:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105055:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105058:	53                   	push   %ebx
80105059:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010505c:	50                   	push   %eax
8010505d:	6a 00                	push   $0x0
8010505f:	e8 ac f9 ff ff       	call   80104a10 <argstr>
80105064:	83 c4 10             	add    $0x10,%esp
80105067:	85 c0                	test   %eax,%eax
80105069:	0f 88 7a 01 00 00    	js     801051e9 <sys_unlink+0x199>
  begin_op();
8010506f:	e8 ec dc ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105074:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105077:	83 ec 08             	sub    $0x8,%esp
8010507a:	53                   	push   %ebx
8010507b:	ff 75 c0             	push   -0x40(%ebp)
8010507e:	e8 3d d0 ff ff       	call   801020c0 <nameiparent>
80105083:	83 c4 10             	add    $0x10,%esp
80105086:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105089:	85 c0                	test   %eax,%eax
8010508b:	0f 84 62 01 00 00    	je     801051f3 <sys_unlink+0x1a3>
  ilock(dp);
80105091:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105094:	83 ec 0c             	sub    $0xc,%esp
80105097:	57                   	push   %edi
80105098:	e8 e3 c6 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010509d:	58                   	pop    %eax
8010509e:	5a                   	pop    %edx
8010509f:	68 f8 7d 10 80       	push   $0x80107df8
801050a4:	53                   	push   %ebx
801050a5:	e8 16 cc ff ff       	call   80101cc0 <namecmp>
801050aa:	83 c4 10             	add    $0x10,%esp
801050ad:	85 c0                	test   %eax,%eax
801050af:	0f 84 fb 00 00 00    	je     801051b0 <sys_unlink+0x160>
801050b5:	83 ec 08             	sub    $0x8,%esp
801050b8:	68 f7 7d 10 80       	push   $0x80107df7
801050bd:	53                   	push   %ebx
801050be:	e8 fd cb ff ff       	call   80101cc0 <namecmp>
801050c3:	83 c4 10             	add    $0x10,%esp
801050c6:	85 c0                	test   %eax,%eax
801050c8:	0f 84 e2 00 00 00    	je     801051b0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801050ce:	83 ec 04             	sub    $0x4,%esp
801050d1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050d4:	50                   	push   %eax
801050d5:	53                   	push   %ebx
801050d6:	57                   	push   %edi
801050d7:	e8 04 cc ff ff       	call   80101ce0 <dirlookup>
801050dc:	83 c4 10             	add    $0x10,%esp
801050df:	89 c3                	mov    %eax,%ebx
801050e1:	85 c0                	test   %eax,%eax
801050e3:	0f 84 c7 00 00 00    	je     801051b0 <sys_unlink+0x160>
  ilock(ip);
801050e9:	83 ec 0c             	sub    $0xc,%esp
801050ec:	50                   	push   %eax
801050ed:	e8 8e c6 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
801050f2:	83 c4 10             	add    $0x10,%esp
801050f5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801050fa:	0f 8e 1c 01 00 00    	jle    8010521c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105100:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105105:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105108:	74 66                	je     80105170 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010510a:	83 ec 04             	sub    $0x4,%esp
8010510d:	6a 10                	push   $0x10
8010510f:	6a 00                	push   $0x0
80105111:	57                   	push   %edi
80105112:	e8 79 f5 ff ff       	call   80104690 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105117:	6a 10                	push   $0x10
80105119:	ff 75 c4             	push   -0x3c(%ebp)
8010511c:	57                   	push   %edi
8010511d:	ff 75 b4             	push   -0x4c(%ebp)
80105120:	e8 6b ca ff ff       	call   80101b90 <writei>
80105125:	83 c4 20             	add    $0x20,%esp
80105128:	83 f8 10             	cmp    $0x10,%eax
8010512b:	0f 85 de 00 00 00    	jne    8010520f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105131:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105136:	0f 84 94 00 00 00    	je     801051d0 <sys_unlink+0x180>
  iunlockput(dp);
8010513c:	83 ec 0c             	sub    $0xc,%esp
8010513f:	ff 75 b4             	push   -0x4c(%ebp)
80105142:	e8 c9 c8 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105147:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010514c:	89 1c 24             	mov    %ebx,(%esp)
8010514f:	e8 7c c5 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105154:	89 1c 24             	mov    %ebx,(%esp)
80105157:	e8 b4 c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010515c:	e8 6f dc ff ff       	call   80102dd0 <end_op>
  return 0;
80105161:	83 c4 10             	add    $0x10,%esp
80105164:	31 c0                	xor    %eax,%eax
}
80105166:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105169:	5b                   	pop    %ebx
8010516a:	5e                   	pop    %esi
8010516b:	5f                   	pop    %edi
8010516c:	5d                   	pop    %ebp
8010516d:	c3                   	ret    
8010516e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105170:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105174:	76 94                	jbe    8010510a <sys_unlink+0xba>
80105176:	be 20 00 00 00       	mov    $0x20,%esi
8010517b:	eb 0b                	jmp    80105188 <sys_unlink+0x138>
8010517d:	8d 76 00             	lea    0x0(%esi),%esi
80105180:	83 c6 10             	add    $0x10,%esi
80105183:	3b 73 58             	cmp    0x58(%ebx),%esi
80105186:	73 82                	jae    8010510a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105188:	6a 10                	push   $0x10
8010518a:	56                   	push   %esi
8010518b:	57                   	push   %edi
8010518c:	53                   	push   %ebx
8010518d:	e8 fe c8 ff ff       	call   80101a90 <readi>
80105192:	83 c4 10             	add    $0x10,%esp
80105195:	83 f8 10             	cmp    $0x10,%eax
80105198:	75 68                	jne    80105202 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010519a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010519f:	74 df                	je     80105180 <sys_unlink+0x130>
    iunlockput(ip);
801051a1:	83 ec 0c             	sub    $0xc,%esp
801051a4:	53                   	push   %ebx
801051a5:	e8 66 c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801051aa:	83 c4 10             	add    $0x10,%esp
801051ad:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801051b0:	83 ec 0c             	sub    $0xc,%esp
801051b3:	ff 75 b4             	push   -0x4c(%ebp)
801051b6:	e8 55 c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
801051bb:	e8 10 dc ff ff       	call   80102dd0 <end_op>
  return -1;
801051c0:	83 c4 10             	add    $0x10,%esp
801051c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051c8:	eb 9c                	jmp    80105166 <sys_unlink+0x116>
801051ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801051d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801051d3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801051d6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801051db:	50                   	push   %eax
801051dc:	e8 ef c4 ff ff       	call   801016d0 <iupdate>
801051e1:	83 c4 10             	add    $0x10,%esp
801051e4:	e9 53 ff ff ff       	jmp    8010513c <sys_unlink+0xec>
    return -1;
801051e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ee:	e9 73 ff ff ff       	jmp    80105166 <sys_unlink+0x116>
    end_op();
801051f3:	e8 d8 db ff ff       	call   80102dd0 <end_op>
    return -1;
801051f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051fd:	e9 64 ff ff ff       	jmp    80105166 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105202:	83 ec 0c             	sub    $0xc,%esp
80105205:	68 1c 7e 10 80       	push   $0x80107e1c
8010520a:	e8 71 b1 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010520f:	83 ec 0c             	sub    $0xc,%esp
80105212:	68 2e 7e 10 80       	push   $0x80107e2e
80105217:	e8 64 b1 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010521c:	83 ec 0c             	sub    $0xc,%esp
8010521f:	68 0a 7e 10 80       	push   $0x80107e0a
80105224:	e8 57 b1 ff ff       	call   80100380 <panic>
80105229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105230 <sys_open>:

int
sys_open(void)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	57                   	push   %edi
80105234:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105235:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105238:	53                   	push   %ebx
80105239:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010523c:	50                   	push   %eax
8010523d:	6a 00                	push   $0x0
8010523f:	e8 cc f7 ff ff       	call   80104a10 <argstr>
80105244:	83 c4 10             	add    $0x10,%esp
80105247:	85 c0                	test   %eax,%eax
80105249:	0f 88 8e 00 00 00    	js     801052dd <sys_open+0xad>
8010524f:	83 ec 08             	sub    $0x8,%esp
80105252:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105255:	50                   	push   %eax
80105256:	6a 01                	push   $0x1
80105258:	e8 f3 f6 ff ff       	call   80104950 <argint>
8010525d:	83 c4 10             	add    $0x10,%esp
80105260:	85 c0                	test   %eax,%eax
80105262:	78 79                	js     801052dd <sys_open+0xad>
    return -1;

  begin_op();
80105264:	e8 f7 da ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
80105269:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010526d:	75 79                	jne    801052e8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010526f:	83 ec 0c             	sub    $0xc,%esp
80105272:	ff 75 e0             	push   -0x20(%ebp)
80105275:	e8 26 ce ff ff       	call   801020a0 <namei>
8010527a:	83 c4 10             	add    $0x10,%esp
8010527d:	89 c6                	mov    %eax,%esi
8010527f:	85 c0                	test   %eax,%eax
80105281:	0f 84 7e 00 00 00    	je     80105305 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105287:	83 ec 0c             	sub    $0xc,%esp
8010528a:	50                   	push   %eax
8010528b:	e8 f0 c4 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105290:	83 c4 10             	add    $0x10,%esp
80105293:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105298:	0f 84 c2 00 00 00    	je     80105360 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010529e:	e8 8d bb ff ff       	call   80100e30 <filealloc>
801052a3:	89 c7                	mov    %eax,%edi
801052a5:	85 c0                	test   %eax,%eax
801052a7:	74 23                	je     801052cc <sys_open+0x9c>
  struct proc *curproc = myproc();
801052a9:	e8 f2 e6 ff ff       	call   801039a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801052ae:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801052b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052b4:	85 d2                	test   %edx,%edx
801052b6:	74 60                	je     80105318 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801052b8:	83 c3 01             	add    $0x1,%ebx
801052bb:	83 fb 10             	cmp    $0x10,%ebx
801052be:	75 f0                	jne    801052b0 <sys_open+0x80>
    if(f)
      fileclose(f);
801052c0:	83 ec 0c             	sub    $0xc,%esp
801052c3:	57                   	push   %edi
801052c4:	e8 27 bc ff ff       	call   80100ef0 <fileclose>
801052c9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801052cc:	83 ec 0c             	sub    $0xc,%esp
801052cf:	56                   	push   %esi
801052d0:	e8 3b c7 ff ff       	call   80101a10 <iunlockput>
    end_op();
801052d5:	e8 f6 da ff ff       	call   80102dd0 <end_op>
    return -1;
801052da:	83 c4 10             	add    $0x10,%esp
801052dd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052e2:	eb 6d                	jmp    80105351 <sys_open+0x121>
801052e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801052e8:	83 ec 0c             	sub    $0xc,%esp
801052eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052ee:	31 c9                	xor    %ecx,%ecx
801052f0:	ba 02 00 00 00       	mov    $0x2,%edx
801052f5:	6a 00                	push   $0x0
801052f7:	e8 14 f8 ff ff       	call   80104b10 <create>
    if(ip == 0){
801052fc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801052ff:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105301:	85 c0                	test   %eax,%eax
80105303:	75 99                	jne    8010529e <sys_open+0x6e>
      end_op();
80105305:	e8 c6 da ff ff       	call   80102dd0 <end_op>
      return -1;
8010530a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010530f:	eb 40                	jmp    80105351 <sys_open+0x121>
80105311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105318:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010531b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010531f:	56                   	push   %esi
80105320:	e8 3b c5 ff ff       	call   80101860 <iunlock>
  end_op();
80105325:	e8 a6 da ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
8010532a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105330:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105333:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105336:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105339:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010533b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105342:	f7 d0                	not    %eax
80105344:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105347:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010534a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010534d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105351:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105354:	89 d8                	mov    %ebx,%eax
80105356:	5b                   	pop    %ebx
80105357:	5e                   	pop    %esi
80105358:	5f                   	pop    %edi
80105359:	5d                   	pop    %ebp
8010535a:	c3                   	ret    
8010535b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010535f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105360:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105363:	85 c9                	test   %ecx,%ecx
80105365:	0f 84 33 ff ff ff    	je     8010529e <sys_open+0x6e>
8010536b:	e9 5c ff ff ff       	jmp    801052cc <sys_open+0x9c>

80105370 <sys_mkdir>:

int
sys_mkdir(void)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105376:	e8 e5 d9 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010537b:	83 ec 08             	sub    $0x8,%esp
8010537e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105381:	50                   	push   %eax
80105382:	6a 00                	push   $0x0
80105384:	e8 87 f6 ff ff       	call   80104a10 <argstr>
80105389:	83 c4 10             	add    $0x10,%esp
8010538c:	85 c0                	test   %eax,%eax
8010538e:	78 30                	js     801053c0 <sys_mkdir+0x50>
80105390:	83 ec 0c             	sub    $0xc,%esp
80105393:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105396:	31 c9                	xor    %ecx,%ecx
80105398:	ba 01 00 00 00       	mov    $0x1,%edx
8010539d:	6a 00                	push   $0x0
8010539f:	e8 6c f7 ff ff       	call   80104b10 <create>
801053a4:	83 c4 10             	add    $0x10,%esp
801053a7:	85 c0                	test   %eax,%eax
801053a9:	74 15                	je     801053c0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053ab:	83 ec 0c             	sub    $0xc,%esp
801053ae:	50                   	push   %eax
801053af:	e8 5c c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
801053b4:	e8 17 da ff ff       	call   80102dd0 <end_op>
  return 0;
801053b9:	83 c4 10             	add    $0x10,%esp
801053bc:	31 c0                	xor    %eax,%eax
}
801053be:	c9                   	leave  
801053bf:	c3                   	ret    
    end_op();
801053c0:	e8 0b da ff ff       	call   80102dd0 <end_op>
    return -1;
801053c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053ca:	c9                   	leave  
801053cb:	c3                   	ret    
801053cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053d0 <sys_mknod>:

int
sys_mknod(void)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801053d6:	e8 85 d9 ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
801053db:	83 ec 08             	sub    $0x8,%esp
801053de:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053e1:	50                   	push   %eax
801053e2:	6a 00                	push   $0x0
801053e4:	e8 27 f6 ff ff       	call   80104a10 <argstr>
801053e9:	83 c4 10             	add    $0x10,%esp
801053ec:	85 c0                	test   %eax,%eax
801053ee:	78 60                	js     80105450 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801053f0:	83 ec 08             	sub    $0x8,%esp
801053f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053f6:	50                   	push   %eax
801053f7:	6a 01                	push   $0x1
801053f9:	e8 52 f5 ff ff       	call   80104950 <argint>
  if((argstr(0, &path)) < 0 ||
801053fe:	83 c4 10             	add    $0x10,%esp
80105401:	85 c0                	test   %eax,%eax
80105403:	78 4b                	js     80105450 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105405:	83 ec 08             	sub    $0x8,%esp
80105408:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010540b:	50                   	push   %eax
8010540c:	6a 02                	push   $0x2
8010540e:	e8 3d f5 ff ff       	call   80104950 <argint>
     argint(1, &major) < 0 ||
80105413:	83 c4 10             	add    $0x10,%esp
80105416:	85 c0                	test   %eax,%eax
80105418:	78 36                	js     80105450 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010541a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010541e:	83 ec 0c             	sub    $0xc,%esp
80105421:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105425:	ba 03 00 00 00       	mov    $0x3,%edx
8010542a:	50                   	push   %eax
8010542b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010542e:	e8 dd f6 ff ff       	call   80104b10 <create>
     argint(2, &minor) < 0 ||
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	85 c0                	test   %eax,%eax
80105438:	74 16                	je     80105450 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010543a:	83 ec 0c             	sub    $0xc,%esp
8010543d:	50                   	push   %eax
8010543e:	e8 cd c5 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105443:	e8 88 d9 ff ff       	call   80102dd0 <end_op>
  return 0;
80105448:	83 c4 10             	add    $0x10,%esp
8010544b:	31 c0                	xor    %eax,%eax
}
8010544d:	c9                   	leave  
8010544e:	c3                   	ret    
8010544f:	90                   	nop
    end_op();
80105450:	e8 7b d9 ff ff       	call   80102dd0 <end_op>
    return -1;
80105455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010545a:	c9                   	leave  
8010545b:	c3                   	ret    
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105460 <sys_chdir>:

int
sys_chdir(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	56                   	push   %esi
80105464:	53                   	push   %ebx
80105465:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105468:	e8 33 e5 ff ff       	call   801039a0 <myproc>
8010546d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010546f:	e8 ec d8 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105474:	83 ec 08             	sub    $0x8,%esp
80105477:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010547a:	50                   	push   %eax
8010547b:	6a 00                	push   $0x0
8010547d:	e8 8e f5 ff ff       	call   80104a10 <argstr>
80105482:	83 c4 10             	add    $0x10,%esp
80105485:	85 c0                	test   %eax,%eax
80105487:	78 77                	js     80105500 <sys_chdir+0xa0>
80105489:	83 ec 0c             	sub    $0xc,%esp
8010548c:	ff 75 f4             	push   -0xc(%ebp)
8010548f:	e8 0c cc ff ff       	call   801020a0 <namei>
80105494:	83 c4 10             	add    $0x10,%esp
80105497:	89 c3                	mov    %eax,%ebx
80105499:	85 c0                	test   %eax,%eax
8010549b:	74 63                	je     80105500 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010549d:	83 ec 0c             	sub    $0xc,%esp
801054a0:	50                   	push   %eax
801054a1:	e8 da c2 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
801054a6:	83 c4 10             	add    $0x10,%esp
801054a9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054ae:	75 30                	jne    801054e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054b0:	83 ec 0c             	sub    $0xc,%esp
801054b3:	53                   	push   %ebx
801054b4:	e8 a7 c3 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
801054b9:	58                   	pop    %eax
801054ba:	ff 76 68             	push   0x68(%esi)
801054bd:	e8 ee c3 ff ff       	call   801018b0 <iput>
  end_op();
801054c2:	e8 09 d9 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
801054c7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801054ca:	83 c4 10             	add    $0x10,%esp
801054cd:	31 c0                	xor    %eax,%eax
}
801054cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054d2:	5b                   	pop    %ebx
801054d3:	5e                   	pop    %esi
801054d4:	5d                   	pop    %ebp
801054d5:	c3                   	ret    
801054d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054dd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801054e0:	83 ec 0c             	sub    $0xc,%esp
801054e3:	53                   	push   %ebx
801054e4:	e8 27 c5 ff ff       	call   80101a10 <iunlockput>
    end_op();
801054e9:	e8 e2 d8 ff ff       	call   80102dd0 <end_op>
    return -1;
801054ee:	83 c4 10             	add    $0x10,%esp
801054f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054f6:	eb d7                	jmp    801054cf <sys_chdir+0x6f>
801054f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ff:	90                   	nop
    end_op();
80105500:	e8 cb d8 ff ff       	call   80102dd0 <end_op>
    return -1;
80105505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010550a:	eb c3                	jmp    801054cf <sys_chdir+0x6f>
8010550c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105510 <sys_exec>:

int
sys_exec(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	57                   	push   %edi
80105514:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105515:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010551b:	53                   	push   %ebx
8010551c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105522:	50                   	push   %eax
80105523:	6a 00                	push   $0x0
80105525:	e8 e6 f4 ff ff       	call   80104a10 <argstr>
8010552a:	83 c4 10             	add    $0x10,%esp
8010552d:	85 c0                	test   %eax,%eax
8010552f:	0f 88 87 00 00 00    	js     801055bc <sys_exec+0xac>
80105535:	83 ec 08             	sub    $0x8,%esp
80105538:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010553e:	50                   	push   %eax
8010553f:	6a 01                	push   $0x1
80105541:	e8 0a f4 ff ff       	call   80104950 <argint>
80105546:	83 c4 10             	add    $0x10,%esp
80105549:	85 c0                	test   %eax,%eax
8010554b:	78 6f                	js     801055bc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010554d:	83 ec 04             	sub    $0x4,%esp
80105550:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105556:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105558:	68 80 00 00 00       	push   $0x80
8010555d:	6a 00                	push   $0x0
8010555f:	56                   	push   %esi
80105560:	e8 2b f1 ff ff       	call   80104690 <memset>
80105565:	83 c4 10             	add    $0x10,%esp
80105568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010556f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105570:	83 ec 08             	sub    $0x8,%esp
80105573:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105579:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105580:	50                   	push   %eax
80105581:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105587:	01 f8                	add    %edi,%eax
80105589:	50                   	push   %eax
8010558a:	e8 31 f3 ff ff       	call   801048c0 <fetchint>
8010558f:	83 c4 10             	add    $0x10,%esp
80105592:	85 c0                	test   %eax,%eax
80105594:	78 26                	js     801055bc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105596:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010559c:	85 c0                	test   %eax,%eax
8010559e:	74 30                	je     801055d0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055a0:	83 ec 08             	sub    $0x8,%esp
801055a3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801055a6:	52                   	push   %edx
801055a7:	50                   	push   %eax
801055a8:	e8 53 f3 ff ff       	call   80104900 <fetchstr>
801055ad:	83 c4 10             	add    $0x10,%esp
801055b0:	85 c0                	test   %eax,%eax
801055b2:	78 08                	js     801055bc <sys_exec+0xac>
  for(i=0;; i++){
801055b4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801055b7:	83 fb 20             	cmp    $0x20,%ebx
801055ba:	75 b4                	jne    80105570 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801055bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801055bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055c4:	5b                   	pop    %ebx
801055c5:	5e                   	pop    %esi
801055c6:	5f                   	pop    %edi
801055c7:	5d                   	pop    %ebp
801055c8:	c3                   	ret    
801055c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801055d0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055d7:	00 00 00 00 
  return exec(path, argv);
801055db:	83 ec 08             	sub    $0x8,%esp
801055de:	56                   	push   %esi
801055df:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801055e5:	e8 c6 b4 ff ff       	call   80100ab0 <exec>
801055ea:	83 c4 10             	add    $0x10,%esp
}
801055ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055f0:	5b                   	pop    %ebx
801055f1:	5e                   	pop    %esi
801055f2:	5f                   	pop    %edi
801055f3:	5d                   	pop    %ebp
801055f4:	c3                   	ret    
801055f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105600 <sys_pipe>:

int
sys_pipe(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	57                   	push   %edi
80105604:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105605:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105608:	53                   	push   %ebx
80105609:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010560c:	6a 08                	push   $0x8
8010560e:	50                   	push   %eax
8010560f:	6a 00                	push   $0x0
80105611:	e8 8a f3 ff ff       	call   801049a0 <argptr>
80105616:	83 c4 10             	add    $0x10,%esp
80105619:	85 c0                	test   %eax,%eax
8010561b:	78 4a                	js     80105667 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010561d:	83 ec 08             	sub    $0x8,%esp
80105620:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105623:	50                   	push   %eax
80105624:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105627:	50                   	push   %eax
80105628:	e8 03 de ff ff       	call   80103430 <pipealloc>
8010562d:	83 c4 10             	add    $0x10,%esp
80105630:	85 c0                	test   %eax,%eax
80105632:	78 33                	js     80105667 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105634:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105637:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105639:	e8 62 e3 ff ff       	call   801039a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010563e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105640:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105644:	85 f6                	test   %esi,%esi
80105646:	74 28                	je     80105670 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105648:	83 c3 01             	add    $0x1,%ebx
8010564b:	83 fb 10             	cmp    $0x10,%ebx
8010564e:	75 f0                	jne    80105640 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	ff 75 e0             	push   -0x20(%ebp)
80105656:	e8 95 b8 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010565b:	58                   	pop    %eax
8010565c:	ff 75 e4             	push   -0x1c(%ebp)
8010565f:	e8 8c b8 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105664:	83 c4 10             	add    $0x10,%esp
80105667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010566c:	eb 53                	jmp    801056c1 <sys_pipe+0xc1>
8010566e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105670:	8d 73 08             	lea    0x8(%ebx),%esi
80105673:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105677:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010567a:	e8 21 e3 ff ff       	call   801039a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010567f:	31 d2                	xor    %edx,%edx
80105681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105688:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010568c:	85 c9                	test   %ecx,%ecx
8010568e:	74 20                	je     801056b0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105690:	83 c2 01             	add    $0x1,%edx
80105693:	83 fa 10             	cmp    $0x10,%edx
80105696:	75 f0                	jne    80105688 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105698:	e8 03 e3 ff ff       	call   801039a0 <myproc>
8010569d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801056a4:	00 
801056a5:	eb a9                	jmp    80105650 <sys_pipe+0x50>
801056a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801056b0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801056b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056b7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801056b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056bc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801056bf:	31 c0                	xor    %eax,%eax
}
801056c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056c4:	5b                   	pop    %ebx
801056c5:	5e                   	pop    %esi
801056c6:	5f                   	pop    %edi
801056c7:	5d                   	pop    %ebp
801056c8:	c3                   	ret    
801056c9:	66 90                	xchg   %ax,%ax
801056cb:	66 90                	xchg   %ax,%ax
801056cd:	66 90                	xchg   %ax,%ax
801056cf:	90                   	nop

801056d0 <sys_fork>:
#include "trace.h"

int
sys_fork(void)
{
  return fork();
801056d0:	e9 6b e4 ff ff       	jmp    80103b40 <fork>
801056d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056e0 <sys_exit>:
}

int
sys_exit(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	83 ec 08             	sub    $0x8,%esp
  exit();
801056e6:	e8 d5 e6 ff ff       	call   80103dc0 <exit>
  return 0;  // not reached
}
801056eb:	31 c0                	xor    %eax,%eax
801056ed:	c9                   	leave  
801056ee:	c3                   	ret    
801056ef:	90                   	nop

801056f0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801056f0:	e9 fb e7 ff ff       	jmp    80103ef0 <wait>
801056f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105700 <sys_kill>:
}

int
sys_kill(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105706:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105709:	50                   	push   %eax
8010570a:	6a 00                	push   $0x0
8010570c:	e8 3f f2 ff ff       	call   80104950 <argint>
80105711:	83 c4 10             	add    $0x10,%esp
80105714:	85 c0                	test   %eax,%eax
80105716:	78 18                	js     80105730 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105718:	83 ec 0c             	sub    $0xc,%esp
8010571b:	ff 75 f4             	push   -0xc(%ebp)
8010571e:	e8 6d ea ff ff       	call   80104190 <kill>
80105723:	83 c4 10             	add    $0x10,%esp
}
80105726:	c9                   	leave  
80105727:	c3                   	ret    
80105728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010572f:	90                   	nop
80105730:	c9                   	leave  
    return -1;
80105731:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105736:	c3                   	ret    
80105737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573e:	66 90                	xchg   %ax,%ax

80105740 <sys_getpid>:

int
sys_getpid(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105746:	e8 55 e2 ff ff       	call   801039a0 <myproc>
8010574b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010574e:	c9                   	leave  
8010574f:	c3                   	ret    

80105750 <sys_sbrk>:

int
sys_sbrk(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105754:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105757:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010575a:	50                   	push   %eax
8010575b:	6a 00                	push   $0x0
8010575d:	e8 ee f1 ff ff       	call   80104950 <argint>
80105762:	83 c4 10             	add    $0x10,%esp
80105765:	85 c0                	test   %eax,%eax
80105767:	78 27                	js     80105790 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105769:	e8 32 e2 ff ff       	call   801039a0 <myproc>
  if(growproc(n) < 0)
8010576e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105771:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105773:	ff 75 f4             	push   -0xc(%ebp)
80105776:	e8 45 e3 ff ff       	call   80103ac0 <growproc>
8010577b:	83 c4 10             	add    $0x10,%esp
8010577e:	85 c0                	test   %eax,%eax
80105780:	78 0e                	js     80105790 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105782:	89 d8                	mov    %ebx,%eax
80105784:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105787:	c9                   	leave  
80105788:	c3                   	ret    
80105789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105790:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105795:	eb eb                	jmp    80105782 <sys_sbrk+0x32>
80105797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579e:	66 90                	xchg   %ax,%ax

801057a0 <sys_sleep>:

int
sys_sleep(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057a7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057aa:	50                   	push   %eax
801057ab:	6a 00                	push   $0x0
801057ad:	e8 9e f1 ff ff       	call   80104950 <argint>
801057b2:	83 c4 10             	add    $0x10,%esp
801057b5:	85 c0                	test   %eax,%eax
801057b7:	0f 88 8a 00 00 00    	js     80105847 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801057bd:	83 ec 0c             	sub    $0xc,%esp
801057c0:	68 00 60 11 80       	push   $0x80116000
801057c5:	e8 06 ee ff ff       	call   801045d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801057ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801057cd:	8b 1d e0 5f 11 80    	mov    0x80115fe0,%ebx
  while(ticks - ticks0 < n){
801057d3:	83 c4 10             	add    $0x10,%esp
801057d6:	85 d2                	test   %edx,%edx
801057d8:	75 27                	jne    80105801 <sys_sleep+0x61>
801057da:	eb 54                	jmp    80105830 <sys_sleep+0x90>
801057dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801057e0:	83 ec 08             	sub    $0x8,%esp
801057e3:	68 00 60 11 80       	push   $0x80116000
801057e8:	68 e0 5f 11 80       	push   $0x80115fe0
801057ed:	e8 7e e8 ff ff       	call   80104070 <sleep>
  while(ticks - ticks0 < n){
801057f2:	a1 e0 5f 11 80       	mov    0x80115fe0,%eax
801057f7:	83 c4 10             	add    $0x10,%esp
801057fa:	29 d8                	sub    %ebx,%eax
801057fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801057ff:	73 2f                	jae    80105830 <sys_sleep+0x90>
    if(myproc()->killed){
80105801:	e8 9a e1 ff ff       	call   801039a0 <myproc>
80105806:	8b 40 24             	mov    0x24(%eax),%eax
80105809:	85 c0                	test   %eax,%eax
8010580b:	74 d3                	je     801057e0 <sys_sleep+0x40>
      release(&tickslock);
8010580d:	83 ec 0c             	sub    $0xc,%esp
80105810:	68 00 60 11 80       	push   $0x80116000
80105815:	e8 56 ed ff ff       	call   80104570 <release>
  }
  release(&tickslock);
  return 0;
}
8010581a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105825:	c9                   	leave  
80105826:	c3                   	ret    
80105827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105830:	83 ec 0c             	sub    $0xc,%esp
80105833:	68 00 60 11 80       	push   $0x80116000
80105838:	e8 33 ed ff ff       	call   80104570 <release>
  return 0;
8010583d:	83 c4 10             	add    $0x10,%esp
80105840:	31 c0                	xor    %eax,%eax
}
80105842:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105845:	c9                   	leave  
80105846:	c3                   	ret    
    return -1;
80105847:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584c:	eb f4                	jmp    80105842 <sys_sleep+0xa2>
8010584e:	66 90                	xchg   %ax,%ax

80105850 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	53                   	push   %ebx
80105854:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105857:	68 00 60 11 80       	push   $0x80116000
8010585c:	e8 6f ed ff ff       	call   801045d0 <acquire>
  xticks = ticks;
80105861:	8b 1d e0 5f 11 80    	mov    0x80115fe0,%ebx
  release(&tickslock);
80105867:	c7 04 24 00 60 11 80 	movl   $0x80116000,(%esp)
8010586e:	e8 fd ec ff ff       	call   80104570 <release>
  return xticks;
}
80105873:	89 d8                	mov    %ebx,%eax
80105875:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105878:	c9                   	leave  
80105879:	c3                   	ret    
8010587a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105880 <sys_toggle>:
int 
sys_toggle(void)
{
		
	state ^= 1;
	if(state == 0){
80105880:	83 35 dc 5f 11 80 01 	xorl   $0x1,0x80115fdc
80105887:	75 1a                	jne    801058a3 <sys_toggle+0x23>
		for(int i = 0; i < SYS_MAX+1; i++)
80105889:	31 c0                	xor    %eax,%eax
8010588b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010588f:	90                   	nop
    			syscall_counts[i] = 0;
80105890:	c7 04 85 60 5f 11 80 	movl   $0x0,-0x7feea0a0(,%eax,4)
80105897:	00 00 00 00 
		for(int i = 0; i < SYS_MAX+1; i++)
8010589b:	83 c0 01             	add    $0x1,%eax
8010589e:	83 f8 1f             	cmp    $0x1f,%eax
801058a1:	75 ed                	jne    80105890 <sys_toggle+0x10>
	}
	else{
		// nothing to be done 
	}
	return 0;
}
801058a3:	31 c0                	xor    %eax,%eax
801058a5:	c3                   	ret    
801058a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ad:	8d 76 00             	lea    0x0(%esi),%esi

801058b0 <sys_print_count>:


int 
sys_print_count(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	56                   	push   %esi
801058b4:	be 01 00 00 00       	mov    $0x1,%esi
801058b9:	53                   	push   %ebx
801058ba:	31 db                	xor    %ebx,%ebx
801058bc:	eb 23                	jmp    801058e1 <sys_print_count+0x31>
801058be:	66 90                	xchg   %ax,%ax
			else if(i == 21)
			{
				cprintf("sys_close %d\n",syscall_counts[i]);
			}
			else{
				cprintf("%d %d\n",i,syscall_counts[i]);
801058c0:	83 ec 04             	sub    $0x4,%esp
801058c3:	50                   	push   %eax
801058c4:	53                   	push   %ebx
801058c5:	68 73 7e 10 80       	push   $0x80107e73
801058ca:	e8 d1 ad ff ff       	call   801006a0 <cprintf>
801058cf:	83 c4 10             	add    $0x10,%esp
	for(int i = 0;i < SYS_MAX+1;i++)
801058d2:	83 fe 1f             	cmp    $0x1f,%esi
801058d5:	0f 84 85 00 00 00    	je     80105960 <sys_print_count+0xb0>
801058db:	83 c3 01             	add    $0x1,%ebx
801058de:	83 c6 01             	add    $0x1,%esi
		if(syscall_counts[i] > 0){
801058e1:	8b 04 9d 60 5f 11 80 	mov    -0x7feea0a0(,%ebx,4),%eax
801058e8:	85 c0                	test   %eax,%eax
801058ea:	7e e6                	jle    801058d2 <sys_print_count+0x22>
			if(i == 1){
801058ec:	83 fb 01             	cmp    $0x1,%ebx
801058ef:	74 27                	je     80105918 <sys_print_count+0x68>
			else if(i == 15){
801058f1:	83 fb 0f             	cmp    $0xf,%ebx
801058f4:	74 3a                	je     80105930 <sys_print_count+0x80>
			else if(i == 16)
801058f6:	83 fb 10             	cmp    $0x10,%ebx
801058f9:	74 4d                	je     80105948 <sys_print_count+0x98>
			else if(i == 21)
801058fb:	83 fb 15             	cmp    $0x15,%ebx
801058fe:	75 c0                	jne    801058c0 <sys_print_count+0x10>
				cprintf("sys_close %d\n",syscall_counts[i]);
80105900:	83 ec 08             	sub    $0x8,%esp
80105903:	50                   	push   %eax
80105904:	68 65 7e 10 80       	push   $0x80107e65
80105909:	e8 92 ad ff ff       	call   801006a0 <cprintf>
8010590e:	83 c4 10             	add    $0x10,%esp
80105911:	eb c8                	jmp    801058db <sys_print_count+0x2b>
80105913:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105917:	90                   	nop
				cprintf("sys_fork %d\n",syscall_counts[i]);
80105918:	83 ec 08             	sub    $0x8,%esp
8010591b:	50                   	push   %eax
8010591c:	68 3d 7e 10 80       	push   $0x80107e3d
80105921:	e8 7a ad ff ff       	call   801006a0 <cprintf>
80105926:	83 c4 10             	add    $0x10,%esp
80105929:	eb b0                	jmp    801058db <sys_print_count+0x2b>
8010592b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010592f:	90                   	nop
				cprintf("sys_open %d\n",syscall_counts[i]);
80105930:	83 ec 08             	sub    $0x8,%esp
80105933:	50                   	push   %eax
80105934:	68 4a 7e 10 80       	push   $0x80107e4a
80105939:	e8 62 ad ff ff       	call   801006a0 <cprintf>
8010593e:	83 c4 10             	add    $0x10,%esp
80105941:	eb 98                	jmp    801058db <sys_print_count+0x2b>
80105943:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105947:	90                   	nop
				cprintf("sys_write %d\n",syscall_counts[i]);
80105948:	83 ec 08             	sub    $0x8,%esp
8010594b:	50                   	push   %eax
8010594c:	68 57 7e 10 80       	push   $0x80107e57
80105951:	e8 4a ad ff ff       	call   801006a0 <cprintf>
80105956:	83 c4 10             	add    $0x10,%esp
80105959:	eb 80                	jmp    801058db <sys_print_count+0x2b>
8010595b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010595f:	90                   	nop
			}
			
		}
	}
	return 0;
}
80105960:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105963:	31 c0                	xor    %eax,%eax
80105965:	5b                   	pop    %ebx
80105966:	5e                   	pop    %esi
80105967:	5d                   	pop    %ebp
80105968:	c3                   	ret    
80105969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105970 <sys_add>:

/* next two calls */

int 
sys_add(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 20             	sub    $0x20,%esp
	int a, b;
	if (argint(0, &a) < 0 || argint(1, &b) < 0)
80105976:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105979:	50                   	push   %eax
8010597a:	6a 00                	push   $0x0
8010597c:	e8 cf ef ff ff       	call   80104950 <argint>
80105981:	83 c4 10             	add    $0x10,%esp
80105984:	85 c0                	test   %eax,%eax
80105986:	78 20                	js     801059a8 <sys_add+0x38>
80105988:	83 ec 08             	sub    $0x8,%esp
8010598b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010598e:	50                   	push   %eax
8010598f:	6a 01                	push   $0x1
80105991:	e8 ba ef ff ff       	call   80104950 <argint>
80105996:	83 c4 10             	add    $0x10,%esp
80105999:	85 c0                	test   %eax,%eax
8010599b:	78 0b                	js     801059a8 <sys_add+0x38>
	return -1;
	return a + b;
8010599d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059a0:	03 45 f0             	add    -0x10(%ebp),%eax

}
801059a3:	c9                   	leave  
801059a4:	c3                   	ret    
801059a5:	8d 76 00             	lea    0x0(%esi),%esi
801059a8:	c9                   	leave  
	return -1;
801059a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059ae:	c3                   	ret    
801059af:	90                   	nop

801059b0 <sys_ps>:

int
sys_ps(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	53                   	push   %ebx
801059b4:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801059b9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  acquire(&ptable.lock);
801059bc:	68 20 2d 11 80       	push   $0x80112d20
801059c1:	e8 0a ec ff ff       	call   801045d0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801059c6:	83 c4 10             	add    $0x10,%esp
801059c9:	eb 13                	jmp    801059de <sys_ps+0x2e>
801059cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059cf:	90                   	nop
801059d0:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
801059d6:	81 fb c0 5f 11 80    	cmp    $0x80115fc0,%ebx
801059dc:	74 2c                	je     80105a0a <sys_ps+0x5a>
    if(p->state != UNUSED){
801059de:	8b 43 a0             	mov    -0x60(%ebx),%eax
801059e1:	85 c0                	test   %eax,%eax
801059e3:	74 eb                	je     801059d0 <sys_ps+0x20>
      cprintf("pid:%d name:%s\n", p->pid, p->name);
801059e5:	83 ec 04             	sub    $0x4,%esp
801059e8:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801059e9:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
      cprintf("pid:%d name:%s\n", p->pid, p->name);
801059ef:	ff b3 dc fe ff ff    	push   -0x124(%ebx)
801059f5:	68 7a 7e 10 80       	push   $0x80107e7a
801059fa:	e8 a1 ac ff ff       	call   801006a0 <cprintf>
801059ff:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105a02:	81 fb c0 5f 11 80    	cmp    $0x80115fc0,%ebx
80105a08:	75 d4                	jne    801059de <sys_ps+0x2e>
    }
  }
  release(&ptable.lock);
80105a0a:	83 ec 0c             	sub    $0xc,%esp
80105a0d:	68 20 2d 11 80       	push   $0x80112d20
80105a12:	e8 59 eb ff ff       	call   80104570 <release>
  return 0;
}
80105a17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a1a:	31 c0                	xor    %eax,%eax
80105a1c:	c9                   	leave  
80105a1d:	c3                   	ret    
80105a1e:	66 90                	xchg   %ax,%ax

80105a20 <sys_send>:


int sys_send(void){
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	57                   	push   %edi
80105a24:	56                   	push   %esi
	int sender_pid, rec_pid;
	char* msg;
	struct proc *p; 
	if(argint(0, &sender_pid) < 0 || argint(1, &rec_pid) < 0 || argptr(2, &msg, MSG_LEN) < 0) return -1;
80105a25:	8d 45 dc             	lea    -0x24(%ebp),%eax
int sys_send(void){
80105a28:	53                   	push   %ebx
80105a29:	83 ec 24             	sub    $0x24,%esp
	if(argint(0, &sender_pid) < 0 || argint(1, &rec_pid) < 0 || argptr(2, &msg, MSG_LEN) < 0) return -1;
80105a2c:	50                   	push   %eax
80105a2d:	6a 00                	push   $0x0
80105a2f:	e8 1c ef ff ff       	call   80104950 <argint>
80105a34:	83 c4 10             	add    $0x10,%esp
80105a37:	85 c0                	test   %eax,%eax
80105a39:	0f 88 b9 00 00 00    	js     80105af8 <sys_send+0xd8>
80105a3f:	83 ec 08             	sub    $0x8,%esp
80105a42:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105a45:	50                   	push   %eax
80105a46:	6a 01                	push   $0x1
80105a48:	e8 03 ef ff ff       	call   80104950 <argint>
80105a4d:	83 c4 10             	add    $0x10,%esp
80105a50:	85 c0                	test   %eax,%eax
80105a52:	0f 88 a0 00 00 00    	js     80105af8 <sys_send+0xd8>
80105a58:	83 ec 04             	sub    $0x4,%esp
80105a5b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a5e:	6a 08                	push   $0x8
80105a60:	50                   	push   %eax
80105a61:	6a 02                	push   $0x2
80105a63:	e8 38 ef ff ff       	call   801049a0 <argptr>
80105a68:	83 c4 10             	add    $0x10,%esp
80105a6b:	85 c0                	test   %eax,%eax
80105a6d:	0f 88 85 00 00 00    	js     80105af8 <sys_send+0xd8>
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
	    if (p->pid == rec_pid) {
80105a73:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105a76:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80105a7b:	eb 11                	jmp    80105a8e <sys_send+0x6e>
80105a7d:	8d 76 00             	lea    0x0(%esi),%esi
80105a80:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
80105a86:	81 fb 54 5f 11 80    	cmp    $0x80115f54,%ebx
80105a8c:	74 6a                	je     80105af8 <sys_send+0xd8>
	    if (p->pid == rec_pid) {
80105a8e:	39 43 10             	cmp    %eax,0x10(%ebx)
80105a91:	75 ed                	jne    80105a80 <sys_send+0x60>
	      acquire(&p->msg_lock);
80105a93:	83 ec 0c             	sub    $0xc,%esp
80105a96:	8d bb 90 00 00 00    	lea    0x90(%ebx),%edi
80105a9c:	57                   	push   %edi
80105a9d:	e8 2e eb ff ff       	call   801045d0 <acquire>
	      if (p->has_msg) {
80105aa2:	8b b3 84 00 00 00    	mov    0x84(%ebx),%esi
80105aa8:	83 c4 10             	add    $0x10,%esp
80105aab:	85 f6                	test   %esi,%esi
80105aad:	75 58                	jne    80105b07 <sys_send+0xe7>
		release(&p->msg_lock);
		return -1;  // Receiver already has a message
	      }

	      memmove(p->msg, msg, MSG_LEN);
80105aaf:	83 ec 04             	sub    $0x4,%esp
80105ab2:	8d 43 7c             	lea    0x7c(%ebx),%eax
80105ab5:	6a 08                	push   $0x8
80105ab7:	ff 75 e4             	push   -0x1c(%ebp)
80105aba:	50                   	push   %eax
80105abb:	e8 70 ec ff ff       	call   80104730 <memmove>
	      p->has_msg = 1;
80105ac0:	c7 83 84 00 00 00 01 	movl   $0x1,0x84(%ebx)
80105ac7:	00 00 00 
	      p->sender = myproc();  // Optional
80105aca:	e8 d1 de ff ff       	call   801039a0 <myproc>
	      wakeup(p);  // In case receiver is sleeping
80105acf:	89 1c 24             	mov    %ebx,(%esp)
	      p->sender = myproc();  // Optional
80105ad2:	89 83 c4 00 00 00    	mov    %eax,0xc4(%ebx)
	      wakeup(p);  // In case receiver is sleeping
80105ad8:	e8 53 e6 ff ff       	call   80104130 <wakeup>
	      release(&p->msg_lock);
80105add:	89 3c 24             	mov    %edi,(%esp)
80105ae0:	e8 8b ea ff ff       	call   80104570 <release>
	      return 0;
80105ae5:	83 c4 10             	add    $0x10,%esp
	    }
	}
	return -1; // no receiver found 
}
80105ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aeb:	89 f0                	mov    %esi,%eax
80105aed:	5b                   	pop    %ebx
80105aee:	5e                   	pop    %esi
80105aef:	5f                   	pop    %edi
80105af0:	5d                   	pop    %ebp
80105af1:	c3                   	ret    
80105af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105af8:	8d 65 f4             	lea    -0xc(%ebp),%esp
	if(argint(0, &sender_pid) < 0 || argint(1, &rec_pid) < 0 || argptr(2, &msg, MSG_LEN) < 0) return -1;
80105afb:	be ff ff ff ff       	mov    $0xffffffff,%esi
}
80105b00:	5b                   	pop    %ebx
80105b01:	89 f0                	mov    %esi,%eax
80105b03:	5e                   	pop    %esi
80105b04:	5f                   	pop    %edi
80105b05:	5d                   	pop    %ebp
80105b06:	c3                   	ret    
		release(&p->msg_lock);
80105b07:	83 ec 0c             	sub    $0xc,%esp
		return -1;  // Receiver already has a message
80105b0a:	be ff ff ff ff       	mov    $0xffffffff,%esi
		release(&p->msg_lock);
80105b0f:	57                   	push   %edi
80105b10:	e8 5b ea ff ff       	call   80104570 <release>
		return -1;  // Receiver already has a message
80105b15:	83 c4 10             	add    $0x10,%esp
80105b18:	eb ce                	jmp    80105ae8 <sys_send+0xc8>
80105b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b20 <sys_recv>:


int sys_recv(void){
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	56                   	push   %esi
80105b24:	53                   	push   %ebx
80105b25:	83 ec 10             	sub    $0x10,%esp
	char* msg;
	struct proc *p = myproc();
80105b28:	e8 73 de ff ff       	call   801039a0 <myproc>
	if(argptr(0, &msg, MSG_LEN) < 0) return -1;
80105b2d:	83 ec 04             	sub    $0x4,%esp
	struct proc *p = myproc();
80105b30:	89 c3                	mov    %eax,%ebx
	if(argptr(0, &msg, MSG_LEN) < 0) return -1;
80105b32:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b35:	6a 08                	push   $0x8
80105b37:	50                   	push   %eax
80105b38:	6a 00                	push   $0x0
80105b3a:	e8 61 ee ff ff       	call   801049a0 <argptr>
80105b3f:	83 c4 10             	add    $0x10,%esp
80105b42:	85 c0                	test   %eax,%eax
80105b44:	78 68                	js     80105bae <sys_recv+0x8e>
	acquire(&p->msg_lock);
80105b46:	83 ec 0c             	sub    $0xc,%esp
80105b49:	8d b3 90 00 00 00    	lea    0x90(%ebx),%esi
80105b4f:	56                   	push   %esi
80105b50:	e8 7b ea ff ff       	call   801045d0 <acquire>
	while(!p->has_msg){
80105b55:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80105b5b:	83 c4 10             	add    $0x10,%esp
80105b5e:	85 d2                	test   %edx,%edx
80105b60:	75 1d                	jne    80105b7f <sys_recv+0x5f>
80105b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		sleep(p, &p->msg_lock);
80105b68:	83 ec 08             	sub    $0x8,%esp
80105b6b:	56                   	push   %esi
80105b6c:	53                   	push   %ebx
80105b6d:	e8 fe e4 ff ff       	call   80104070 <sleep>
	while(!p->has_msg){
80105b72:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80105b78:	83 c4 10             	add    $0x10,%esp
80105b7b:	85 c0                	test   %eax,%eax
80105b7d:	74 e9                	je     80105b68 <sys_recv+0x48>
	}
	memmove(msg,p->msg,MSG_LEN);
80105b7f:	83 ec 04             	sub    $0x4,%esp
80105b82:	8d 43 7c             	lea    0x7c(%ebx),%eax
80105b85:	6a 08                	push   $0x8
80105b87:	50                   	push   %eax
80105b88:	ff 75 f4             	push   -0xc(%ebp)
80105b8b:	e8 a0 eb ff ff       	call   80104730 <memmove>
	p->has_msg = 0;
80105b90:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80105b97:	00 00 00 
	release(&p->msg_lock);
80105b9a:	89 34 24             	mov    %esi,(%esp)
80105b9d:	e8 ce e9 ff ff       	call   80104570 <release>
	
	return 0;
80105ba2:	83 c4 10             	add    $0x10,%esp
80105ba5:	31 c0                	xor    %eax,%eax
}
80105ba7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105baa:	5b                   	pop    %ebx
80105bab:	5e                   	pop    %esi
80105bac:	5d                   	pop    %ebp
80105bad:	c3                   	ret    
	if(argptr(0, &msg, MSG_LEN) < 0) return -1;
80105bae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bb3:	eb f2                	jmp    80105ba7 <sys_recv+0x87>
80105bb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bc0 <sys_send_multi>:

int
sys_send_multi(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	56                   	push   %esi
80105bc4:	53                   	push   %ebx
  int sender_pid;
  int *rec_pids;
  char *msg;

  if (argint(0, &sender_pid) < 0 ||
80105bc5:	8d 45 ec             	lea    -0x14(%ebp),%eax
{
80105bc8:	83 ec 18             	sub    $0x18,%esp
  if (argint(0, &sender_pid) < 0 ||
80105bcb:	50                   	push   %eax
80105bcc:	6a 00                	push   $0x0
80105bce:	e8 7d ed ff ff       	call   80104950 <argint>
80105bd3:	83 c4 10             	add    $0x10,%esp
80105bd6:	85 c0                	test   %eax,%eax
80105bd8:	0f 88 d2 00 00 00    	js     80105cb0 <sys_send_multi+0xf0>
      argptr(1, (void*)&rec_pids, sizeof(int) * NPROC) < 0 ||
80105bde:	83 ec 04             	sub    $0x4,%esp
80105be1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105be4:	68 00 01 00 00       	push   $0x100
80105be9:	50                   	push   %eax
80105bea:	6a 01                	push   $0x1
80105bec:	e8 af ed ff ff       	call   801049a0 <argptr>
  if (argint(0, &sender_pid) < 0 ||
80105bf1:	83 c4 10             	add    $0x10,%esp
80105bf4:	85 c0                	test   %eax,%eax
80105bf6:	0f 88 b4 00 00 00    	js     80105cb0 <sys_send_multi+0xf0>
      argptr(2, &msg, 8) < 0)
80105bfc:	83 ec 04             	sub    $0x4,%esp
80105bff:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c02:	6a 08                	push   $0x8
80105c04:	50                   	push   %eax
80105c05:	6a 02                	push   $0x2
80105c07:	e8 94 ed ff ff       	call   801049a0 <argptr>
      argptr(1, (void*)&rec_pids, sizeof(int) * NPROC) < 0 ||
80105c0c:	83 c4 10             	add    $0x10,%esp
80105c0f:	85 c0                	test   %eax,%eax
80105c11:	0f 88 99 00 00 00    	js     80105cb0 <sys_send_multi+0xf0>
80105c17:	31 f6                	xor    %esi,%esi
80105c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;

  struct proc *p;
  for (int i = 0; i < NPROC && rec_pids[i] != -1; i++) {
80105c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c23:	8b 04 30             	mov    (%eax,%esi,1),%eax
80105c26:	83 f8 ff             	cmp    $0xffffffff,%eax
80105c29:	74 7c                	je     80105ca7 <sys_send_multi+0xe7>
80105c2b:	bb d0 2d 11 80       	mov    $0x80112dd0,%ebx
80105c30:	eb 1a                	jmp    80105c4c <sys_send_multi+0x8c>
80105c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105c38:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
80105c3e:	81 fb d0 5f 11 80    	cmp    $0x80115fd0,%ebx
80105c44:	74 52                	je     80105c98 <sys_send_multi+0xd8>
      if (p->pid == rec_pids[i]) {
80105c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c49:	8b 04 30             	mov    (%eax,%esi,1),%eax
80105c4c:	39 43 94             	cmp    %eax,-0x6c(%ebx)
80105c4f:	75 e7                	jne    80105c38 <sys_send_multi+0x78>
        memmove(p->msg, msg, 8);
80105c51:	83 ec 04             	sub    $0x4,%esp
80105c54:	6a 08                	push   $0x8
80105c56:	ff 75 f4             	push   -0xc(%ebp)
80105c59:	53                   	push   %ebx
80105c5a:	e8 d1 ea ff ff       	call   80104730 <memmove>
        p->has_msg = 1;

        if (p->msg_handler && p->tf) {
80105c5f:	8b 43 0c             	mov    0xc(%ebx),%eax
        p->has_msg = 1;
80105c62:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
        if (p->msg_handler && p->tf) {
80105c69:	83 c4 10             	add    $0x10,%esp
80105c6c:	85 c0                	test   %eax,%eax
80105c6e:	74 c8                	je     80105c38 <sys_send_multi+0x78>
80105c70:	8b 53 9c             	mov    -0x64(%ebx),%edx
80105c73:	85 d2                	test   %edx,%edx
80105c75:	74 c1                	je     80105c38 <sys_send_multi+0x78>
          p->saved_eip = p->tf->eip;
80105c77:	8b 4a 38             	mov    0x38(%edx),%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105c7a:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
          p->saved_eip = p->tf->eip;
80105c80:	89 8b 48 ff ff ff    	mov    %ecx,-0xb8(%ebx)
          p->tf->eip = (uint)p->msg_handler; // redirect to handler
80105c86:	89 42 38             	mov    %eax,0x38(%edx)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105c89:	81 fb d0 5f 11 80    	cmp    $0x80115fd0,%ebx
80105c8f:	75 b5                	jne    80105c46 <sys_send_multi+0x86>
80105c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (int i = 0; i < NPROC && rec_pids[i] != -1; i++) {
80105c98:	83 c6 04             	add    $0x4,%esi
80105c9b:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80105ca1:	0f 85 79 ff ff ff    	jne    80105c20 <sys_send_multi+0x60>
        }
      }
    }
  }
  return 0;
80105ca7:	31 c0                	xor    %eax,%eax
}
80105ca9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105cac:	5b                   	pop    %ebx
80105cad:	5e                   	pop    %esi
80105cae:	5d                   	pop    %ebp
80105caf:	c3                   	ret    
    return -1;
80105cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cb5:	eb f2                	jmp    80105ca9 <sys_send_multi+0xe9>
80105cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbe:	66 90                	xchg   %ax,%ax

80105cc0 <sys_register_msg_handler>:

int
sys_register_msg_handler(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	53                   	push   %ebx
  void *fn;
  if (argptr(0, (void*)&fn, sizeof(fn)) < 0)
80105cc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105cc7:	83 ec 18             	sub    $0x18,%esp
  if (argptr(0, (void*)&fn, sizeof(fn)) < 0)
80105cca:	6a 04                	push   $0x4
80105ccc:	50                   	push   %eax
80105ccd:	6a 00                	push   $0x0
80105ccf:	e8 cc ec ff ff       	call   801049a0 <argptr>
80105cd4:	83 c4 10             	add    $0x10,%esp
80105cd7:	85 c0                	test   %eax,%eax
80105cd9:	78 15                	js     80105cf0 <sys_register_msg_handler+0x30>
    return -1;
  myproc()->msg_handler = fn;
80105cdb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80105cde:	e8 bd dc ff ff       	call   801039a0 <myproc>
80105ce3:	89 98 88 00 00 00    	mov    %ebx,0x88(%eax)
  return 0;
80105ce9:	31 c0                	xor    %eax,%eax
}
80105ceb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cee:	c9                   	leave  
80105cef:	c3                   	ret    
    return -1;
80105cf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cf5:	eb f4                	jmp    80105ceb <sys_register_msg_handler+0x2b>
80105cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cfe:	66 90                	xchg   %ax,%ax

80105d00 <sys_sigret>:

int
sys_sigret(void)
{
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	53                   	push   %ebx
80105d04:	83 ec 04             	sub    $0x4,%esp
  myproc()->tf->eip = myproc()->saved_eip;
80105d07:	e8 94 dc ff ff       	call   801039a0 <myproc>
80105d0c:	89 c3                	mov    %eax,%ebx
80105d0e:	e8 8d dc ff ff       	call   801039a0 <myproc>
80105d13:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80105d19:	8b 40 18             	mov    0x18(%eax),%eax
80105d1c:	89 50 38             	mov    %edx,0x38(%eax)
  return 0;
}
80105d1f:	31 c0                	xor    %eax,%eax
80105d21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d24:	c9                   	leave  
80105d25:	c3                   	ret    

80105d26 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d26:	1e                   	push   %ds
  pushl %es
80105d27:	06                   	push   %es
  pushl %fs
80105d28:	0f a0                	push   %fs
  pushl %gs
80105d2a:	0f a8                	push   %gs
  pushal
80105d2c:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d2d:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d31:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d33:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d35:	54                   	push   %esp
  call trap
80105d36:	e8 c5 00 00 00       	call   80105e00 <trap>
  addl $4, %esp
80105d3b:	83 c4 04             	add    $0x4,%esp

80105d3e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d3e:	61                   	popa   
  popl %gs
80105d3f:	0f a9                	pop    %gs
  popl %fs
80105d41:	0f a1                	pop    %fs
  popl %es
80105d43:	07                   	pop    %es
  popl %ds
80105d44:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d45:	83 c4 08             	add    $0x8,%esp
  iret
80105d48:	cf                   	iret   
80105d49:	66 90                	xchg   %ax,%ax
80105d4b:	66 90                	xchg   %ax,%ax
80105d4d:	66 90                	xchg   %ax,%ax
80105d4f:	90                   	nop

80105d50 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d50:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105d51:	31 c0                	xor    %eax,%eax
{
80105d53:	89 e5                	mov    %esp,%ebp
80105d55:	83 ec 08             	sub    $0x8,%esp
80105d58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d5f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d60:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105d67:	c7 04 c5 42 60 11 80 	movl   $0x8e000008,-0x7fee9fbe(,%eax,8)
80105d6e:	08 00 00 8e 
80105d72:	66 89 14 c5 40 60 11 	mov    %dx,-0x7fee9fc0(,%eax,8)
80105d79:	80 
80105d7a:	c1 ea 10             	shr    $0x10,%edx
80105d7d:	66 89 14 c5 46 60 11 	mov    %dx,-0x7fee9fba(,%eax,8)
80105d84:	80 
  for(i = 0; i < 256; i++)
80105d85:	83 c0 01             	add    $0x1,%eax
80105d88:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d8d:	75 d1                	jne    80105d60 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105d8f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d92:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105d97:	c7 05 42 62 11 80 08 	movl   $0xef000008,0x80116242
80105d9e:	00 00 ef 
  initlock(&tickslock, "time");
80105da1:	68 8a 7e 10 80       	push   $0x80107e8a
80105da6:	68 00 60 11 80       	push   $0x80116000
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105dab:	66 a3 40 62 11 80    	mov    %ax,0x80116240
80105db1:	c1 e8 10             	shr    $0x10,%eax
80105db4:	66 a3 46 62 11 80    	mov    %ax,0x80116246
  initlock(&tickslock, "time");
80105dba:	e8 41 e6 ff ff       	call   80104400 <initlock>
}
80105dbf:	83 c4 10             	add    $0x10,%esp
80105dc2:	c9                   	leave  
80105dc3:	c3                   	ret    
80105dc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dcf:	90                   	nop

80105dd0 <idtinit>:

void
idtinit(void)
{
80105dd0:	55                   	push   %ebp
  pd[0] = size-1;
80105dd1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105dd6:	89 e5                	mov    %esp,%ebp
80105dd8:	83 ec 10             	sub    $0x10,%esp
80105ddb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105ddf:	b8 40 60 11 80       	mov    $0x80116040,%eax
80105de4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105de8:	c1 e8 10             	shr    $0x10,%eax
80105deb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105def:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105df2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105df5:	c9                   	leave  
80105df6:	c3                   	ret    
80105df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dfe:	66 90                	xchg   %ax,%ax

80105e00 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	57                   	push   %edi
80105e04:	56                   	push   %esi
80105e05:	53                   	push   %ebx
80105e06:	83 ec 1c             	sub    $0x1c,%esp
80105e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105e0c:	8b 43 30             	mov    0x30(%ebx),%eax
80105e0f:	83 f8 40             	cmp    $0x40,%eax
80105e12:	0f 84 68 01 00 00    	je     80105f80 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105e18:	83 e8 20             	sub    $0x20,%eax
80105e1b:	83 f8 1f             	cmp    $0x1f,%eax
80105e1e:	0f 87 8c 00 00 00    	ja     80105eb0 <trap+0xb0>
80105e24:	ff 24 85 30 7f 10 80 	jmp    *-0x7fef80d0(,%eax,4)
80105e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e2f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105e30:	e8 0b c4 ff ff       	call   80102240 <ideintr>
    lapiceoi();
80105e35:	e8 d6 ca ff ff       	call   80102910 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e3a:	e8 61 db ff ff       	call   801039a0 <myproc>
80105e3f:	85 c0                	test   %eax,%eax
80105e41:	74 1d                	je     80105e60 <trap+0x60>
80105e43:	e8 58 db ff ff       	call   801039a0 <myproc>
80105e48:	8b 50 24             	mov    0x24(%eax),%edx
80105e4b:	85 d2                	test   %edx,%edx
80105e4d:	74 11                	je     80105e60 <trap+0x60>
80105e4f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e53:	83 e0 03             	and    $0x3,%eax
80105e56:	66 83 f8 03          	cmp    $0x3,%ax
80105e5a:	0f 84 e8 01 00 00    	je     80106048 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105e60:	e8 3b db ff ff       	call   801039a0 <myproc>
80105e65:	85 c0                	test   %eax,%eax
80105e67:	74 0f                	je     80105e78 <trap+0x78>
80105e69:	e8 32 db ff ff       	call   801039a0 <myproc>
80105e6e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105e72:	0f 84 b8 00 00 00    	je     80105f30 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e78:	e8 23 db ff ff       	call   801039a0 <myproc>
80105e7d:	85 c0                	test   %eax,%eax
80105e7f:	74 1d                	je     80105e9e <trap+0x9e>
80105e81:	e8 1a db ff ff       	call   801039a0 <myproc>
80105e86:	8b 40 24             	mov    0x24(%eax),%eax
80105e89:	85 c0                	test   %eax,%eax
80105e8b:	74 11                	je     80105e9e <trap+0x9e>
80105e8d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e91:	83 e0 03             	and    $0x3,%eax
80105e94:	66 83 f8 03          	cmp    $0x3,%ax
80105e98:	0f 84 0f 01 00 00    	je     80105fad <trap+0x1ad>
    exit();
}
80105e9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea1:	5b                   	pop    %ebx
80105ea2:	5e                   	pop    %esi
80105ea3:	5f                   	pop    %edi
80105ea4:	5d                   	pop    %ebp
80105ea5:	c3                   	ret    
80105ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ead:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105eb0:	e8 eb da ff ff       	call   801039a0 <myproc>
80105eb5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105eb8:	85 c0                	test   %eax,%eax
80105eba:	0f 84 a2 01 00 00    	je     80106062 <trap+0x262>
80105ec0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105ec4:	0f 84 98 01 00 00    	je     80106062 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105eca:	0f 20 d1             	mov    %cr2,%ecx
80105ecd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ed0:	e8 ab da ff ff       	call   80103980 <cpuid>
80105ed5:	8b 73 30             	mov    0x30(%ebx),%esi
80105ed8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105edb:	8b 43 34             	mov    0x34(%ebx),%eax
80105ede:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105ee1:	e8 ba da ff ff       	call   801039a0 <myproc>
80105ee6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ee9:	e8 b2 da ff ff       	call   801039a0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105eee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ef1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ef4:	51                   	push   %ecx
80105ef5:	57                   	push   %edi
80105ef6:	52                   	push   %edx
80105ef7:	ff 75 e4             	push   -0x1c(%ebp)
80105efa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105efb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105efe:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f01:	56                   	push   %esi
80105f02:	ff 70 10             	push   0x10(%eax)
80105f05:	68 ec 7e 10 80       	push   $0x80107eec
80105f0a:	e8 91 a7 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105f0f:	83 c4 20             	add    $0x20,%esp
80105f12:	e8 89 da ff ff       	call   801039a0 <myproc>
80105f17:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f1e:	e8 7d da ff ff       	call   801039a0 <myproc>
80105f23:	85 c0                	test   %eax,%eax
80105f25:	0f 85 18 ff ff ff    	jne    80105e43 <trap+0x43>
80105f2b:	e9 30 ff ff ff       	jmp    80105e60 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105f30:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105f34:	0f 85 3e ff ff ff    	jne    80105e78 <trap+0x78>
    yield();
80105f3a:	e8 e1 e0 ff ff       	call   80104020 <yield>
80105f3f:	e9 34 ff ff ff       	jmp    80105e78 <trap+0x78>
80105f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f48:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f4b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105f4f:	e8 2c da ff ff       	call   80103980 <cpuid>
80105f54:	57                   	push   %edi
80105f55:	56                   	push   %esi
80105f56:	50                   	push   %eax
80105f57:	68 94 7e 10 80       	push   $0x80107e94
80105f5c:	e8 3f a7 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105f61:	e8 aa c9 ff ff       	call   80102910 <lapiceoi>
    break;
80105f66:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f69:	e8 32 da ff ff       	call   801039a0 <myproc>
80105f6e:	85 c0                	test   %eax,%eax
80105f70:	0f 85 cd fe ff ff    	jne    80105e43 <trap+0x43>
80105f76:	e9 e5 fe ff ff       	jmp    80105e60 <trap+0x60>
80105f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f7f:	90                   	nop
    if(myproc()->killed)
80105f80:	e8 1b da ff ff       	call   801039a0 <myproc>
80105f85:	8b 70 24             	mov    0x24(%eax),%esi
80105f88:	85 f6                	test   %esi,%esi
80105f8a:	0f 85 c8 00 00 00    	jne    80106058 <trap+0x258>
    myproc()->tf = tf;
80105f90:	e8 0b da ff ff       	call   801039a0 <myproc>
80105f95:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105f98:	e8 f3 ea ff ff       	call   80104a90 <syscall>
    if(myproc()->killed)
80105f9d:	e8 fe d9 ff ff       	call   801039a0 <myproc>
80105fa2:	8b 48 24             	mov    0x24(%eax),%ecx
80105fa5:	85 c9                	test   %ecx,%ecx
80105fa7:	0f 84 f1 fe ff ff    	je     80105e9e <trap+0x9e>
}
80105fad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fb0:	5b                   	pop    %ebx
80105fb1:	5e                   	pop    %esi
80105fb2:	5f                   	pop    %edi
80105fb3:	5d                   	pop    %ebp
      exit();
80105fb4:	e9 07 de ff ff       	jmp    80103dc0 <exit>
80105fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105fc0:	e8 3b 02 00 00       	call   80106200 <uartintr>
    lapiceoi();
80105fc5:	e8 46 c9 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fca:	e8 d1 d9 ff ff       	call   801039a0 <myproc>
80105fcf:	85 c0                	test   %eax,%eax
80105fd1:	0f 85 6c fe ff ff    	jne    80105e43 <trap+0x43>
80105fd7:	e9 84 fe ff ff       	jmp    80105e60 <trap+0x60>
80105fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105fe0:	e8 eb c7 ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
80105fe5:	e8 26 c9 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fea:	e8 b1 d9 ff ff       	call   801039a0 <myproc>
80105fef:	85 c0                	test   %eax,%eax
80105ff1:	0f 85 4c fe ff ff    	jne    80105e43 <trap+0x43>
80105ff7:	e9 64 fe ff ff       	jmp    80105e60 <trap+0x60>
80105ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106000:	e8 7b d9 ff ff       	call   80103980 <cpuid>
80106005:	85 c0                	test   %eax,%eax
80106007:	0f 85 28 fe ff ff    	jne    80105e35 <trap+0x35>
      acquire(&tickslock);
8010600d:	83 ec 0c             	sub    $0xc,%esp
80106010:	68 00 60 11 80       	push   $0x80116000
80106015:	e8 b6 e5 ff ff       	call   801045d0 <acquire>
      wakeup(&ticks);
8010601a:	c7 04 24 e0 5f 11 80 	movl   $0x80115fe0,(%esp)
      ticks++;
80106021:	83 05 e0 5f 11 80 01 	addl   $0x1,0x80115fe0
      wakeup(&ticks);
80106028:	e8 03 e1 ff ff       	call   80104130 <wakeup>
      release(&tickslock);
8010602d:	c7 04 24 00 60 11 80 	movl   $0x80116000,(%esp)
80106034:	e8 37 e5 ff ff       	call   80104570 <release>
80106039:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010603c:	e9 f4 fd ff ff       	jmp    80105e35 <trap+0x35>
80106041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106048:	e8 73 dd ff ff       	call   80103dc0 <exit>
8010604d:	e9 0e fe ff ff       	jmp    80105e60 <trap+0x60>
80106052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106058:	e8 63 dd ff ff       	call   80103dc0 <exit>
8010605d:	e9 2e ff ff ff       	jmp    80105f90 <trap+0x190>
80106062:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106065:	e8 16 d9 ff ff       	call   80103980 <cpuid>
8010606a:	83 ec 0c             	sub    $0xc,%esp
8010606d:	56                   	push   %esi
8010606e:	57                   	push   %edi
8010606f:	50                   	push   %eax
80106070:	ff 73 30             	push   0x30(%ebx)
80106073:	68 b8 7e 10 80       	push   $0x80107eb8
80106078:	e8 23 a6 ff ff       	call   801006a0 <cprintf>
      panic("trap");
8010607d:	83 c4 14             	add    $0x14,%esp
80106080:	68 8f 7e 10 80       	push   $0x80107e8f
80106085:	e8 f6 a2 ff ff       	call   80100380 <panic>
8010608a:	66 90                	xchg   %ax,%ax
8010608c:	66 90                	xchg   %ax,%ax
8010608e:	66 90                	xchg   %ax,%ax

80106090 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106090:	a1 40 68 11 80       	mov    0x80116840,%eax
80106095:	85 c0                	test   %eax,%eax
80106097:	74 17                	je     801060b0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106099:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010609e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010609f:	a8 01                	test   $0x1,%al
801060a1:	74 0d                	je     801060b0 <uartgetc+0x20>
801060a3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060a8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801060a9:	0f b6 c0             	movzbl %al,%eax
801060ac:	c3                   	ret    
801060ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801060b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060b5:	c3                   	ret    
801060b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060bd:	8d 76 00             	lea    0x0(%esi),%esi

801060c0 <uartinit>:
{
801060c0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060c1:	31 c9                	xor    %ecx,%ecx
801060c3:	89 c8                	mov    %ecx,%eax
801060c5:	89 e5                	mov    %esp,%ebp
801060c7:	57                   	push   %edi
801060c8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801060cd:	56                   	push   %esi
801060ce:	89 fa                	mov    %edi,%edx
801060d0:	53                   	push   %ebx
801060d1:	83 ec 1c             	sub    $0x1c,%esp
801060d4:	ee                   	out    %al,(%dx)
801060d5:	be fb 03 00 00       	mov    $0x3fb,%esi
801060da:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801060df:	89 f2                	mov    %esi,%edx
801060e1:	ee                   	out    %al,(%dx)
801060e2:	b8 0c 00 00 00       	mov    $0xc,%eax
801060e7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060ec:	ee                   	out    %al,(%dx)
801060ed:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801060f2:	89 c8                	mov    %ecx,%eax
801060f4:	89 da                	mov    %ebx,%edx
801060f6:	ee                   	out    %al,(%dx)
801060f7:	b8 03 00 00 00       	mov    $0x3,%eax
801060fc:	89 f2                	mov    %esi,%edx
801060fe:	ee                   	out    %al,(%dx)
801060ff:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106104:	89 c8                	mov    %ecx,%eax
80106106:	ee                   	out    %al,(%dx)
80106107:	b8 01 00 00 00       	mov    $0x1,%eax
8010610c:	89 da                	mov    %ebx,%edx
8010610e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010610f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106114:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106115:	3c ff                	cmp    $0xff,%al
80106117:	74 78                	je     80106191 <uartinit+0xd1>
  uart = 1;
80106119:	c7 05 40 68 11 80 01 	movl   $0x1,0x80116840
80106120:	00 00 00 
80106123:	89 fa                	mov    %edi,%edx
80106125:	ec                   	in     (%dx),%al
80106126:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010612b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010612c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010612f:	bf b0 7f 10 80       	mov    $0x80107fb0,%edi
80106134:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106139:	6a 00                	push   $0x0
8010613b:	6a 04                	push   $0x4
8010613d:	e8 3e c3 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106142:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106146:	83 c4 10             	add    $0x10,%esp
80106149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106150:	a1 40 68 11 80       	mov    0x80116840,%eax
80106155:	bb 80 00 00 00       	mov    $0x80,%ebx
8010615a:	85 c0                	test   %eax,%eax
8010615c:	75 14                	jne    80106172 <uartinit+0xb2>
8010615e:	eb 23                	jmp    80106183 <uartinit+0xc3>
    microdelay(10);
80106160:	83 ec 0c             	sub    $0xc,%esp
80106163:	6a 0a                	push   $0xa
80106165:	e8 c6 c7 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010616a:	83 c4 10             	add    $0x10,%esp
8010616d:	83 eb 01             	sub    $0x1,%ebx
80106170:	74 07                	je     80106179 <uartinit+0xb9>
80106172:	89 f2                	mov    %esi,%edx
80106174:	ec                   	in     (%dx),%al
80106175:	a8 20                	test   $0x20,%al
80106177:	74 e7                	je     80106160 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106179:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010617d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106182:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106183:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106187:	83 c7 01             	add    $0x1,%edi
8010618a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010618d:	84 c0                	test   %al,%al
8010618f:	75 bf                	jne    80106150 <uartinit+0x90>
}
80106191:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106194:	5b                   	pop    %ebx
80106195:	5e                   	pop    %esi
80106196:	5f                   	pop    %edi
80106197:	5d                   	pop    %ebp
80106198:	c3                   	ret    
80106199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061a0 <uartputc>:
  if(!uart)
801061a0:	a1 40 68 11 80       	mov    0x80116840,%eax
801061a5:	85 c0                	test   %eax,%eax
801061a7:	74 47                	je     801061f0 <uartputc+0x50>
{
801061a9:	55                   	push   %ebp
801061aa:	89 e5                	mov    %esp,%ebp
801061ac:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061ad:	be fd 03 00 00       	mov    $0x3fd,%esi
801061b2:	53                   	push   %ebx
801061b3:	bb 80 00 00 00       	mov    $0x80,%ebx
801061b8:	eb 18                	jmp    801061d2 <uartputc+0x32>
801061ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801061c0:	83 ec 0c             	sub    $0xc,%esp
801061c3:	6a 0a                	push   $0xa
801061c5:	e8 66 c7 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061ca:	83 c4 10             	add    $0x10,%esp
801061cd:	83 eb 01             	sub    $0x1,%ebx
801061d0:	74 07                	je     801061d9 <uartputc+0x39>
801061d2:	89 f2                	mov    %esi,%edx
801061d4:	ec                   	in     (%dx),%al
801061d5:	a8 20                	test   $0x20,%al
801061d7:	74 e7                	je     801061c0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061d9:	8b 45 08             	mov    0x8(%ebp),%eax
801061dc:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061e1:	ee                   	out    %al,(%dx)
}
801061e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061e5:	5b                   	pop    %ebx
801061e6:	5e                   	pop    %esi
801061e7:	5d                   	pop    %ebp
801061e8:	c3                   	ret    
801061e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061f0:	c3                   	ret    
801061f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ff:	90                   	nop

80106200 <uartintr>:

void
uartintr(void)
{
80106200:	55                   	push   %ebp
80106201:	89 e5                	mov    %esp,%ebp
80106203:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106206:	68 90 60 10 80       	push   $0x80106090
8010620b:	e8 70 a6 ff ff       	call   80100880 <consoleintr>
}
80106210:	83 c4 10             	add    $0x10,%esp
80106213:	c9                   	leave  
80106214:	c3                   	ret    

80106215 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106215:	6a 00                	push   $0x0
  pushl $0
80106217:	6a 00                	push   $0x0
  jmp alltraps
80106219:	e9 08 fb ff ff       	jmp    80105d26 <alltraps>

8010621e <vector1>:
.globl vector1
vector1:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $1
80106220:	6a 01                	push   $0x1
  jmp alltraps
80106222:	e9 ff fa ff ff       	jmp    80105d26 <alltraps>

80106227 <vector2>:
.globl vector2
vector2:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $2
80106229:	6a 02                	push   $0x2
  jmp alltraps
8010622b:	e9 f6 fa ff ff       	jmp    80105d26 <alltraps>

80106230 <vector3>:
.globl vector3
vector3:
  pushl $0
80106230:	6a 00                	push   $0x0
  pushl $3
80106232:	6a 03                	push   $0x3
  jmp alltraps
80106234:	e9 ed fa ff ff       	jmp    80105d26 <alltraps>

80106239 <vector4>:
.globl vector4
vector4:
  pushl $0
80106239:	6a 00                	push   $0x0
  pushl $4
8010623b:	6a 04                	push   $0x4
  jmp alltraps
8010623d:	e9 e4 fa ff ff       	jmp    80105d26 <alltraps>

80106242 <vector5>:
.globl vector5
vector5:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $5
80106244:	6a 05                	push   $0x5
  jmp alltraps
80106246:	e9 db fa ff ff       	jmp    80105d26 <alltraps>

8010624b <vector6>:
.globl vector6
vector6:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $6
8010624d:	6a 06                	push   $0x6
  jmp alltraps
8010624f:	e9 d2 fa ff ff       	jmp    80105d26 <alltraps>

80106254 <vector7>:
.globl vector7
vector7:
  pushl $0
80106254:	6a 00                	push   $0x0
  pushl $7
80106256:	6a 07                	push   $0x7
  jmp alltraps
80106258:	e9 c9 fa ff ff       	jmp    80105d26 <alltraps>

8010625d <vector8>:
.globl vector8
vector8:
  pushl $8
8010625d:	6a 08                	push   $0x8
  jmp alltraps
8010625f:	e9 c2 fa ff ff       	jmp    80105d26 <alltraps>

80106264 <vector9>:
.globl vector9
vector9:
  pushl $0
80106264:	6a 00                	push   $0x0
  pushl $9
80106266:	6a 09                	push   $0x9
  jmp alltraps
80106268:	e9 b9 fa ff ff       	jmp    80105d26 <alltraps>

8010626d <vector10>:
.globl vector10
vector10:
  pushl $10
8010626d:	6a 0a                	push   $0xa
  jmp alltraps
8010626f:	e9 b2 fa ff ff       	jmp    80105d26 <alltraps>

80106274 <vector11>:
.globl vector11
vector11:
  pushl $11
80106274:	6a 0b                	push   $0xb
  jmp alltraps
80106276:	e9 ab fa ff ff       	jmp    80105d26 <alltraps>

8010627b <vector12>:
.globl vector12
vector12:
  pushl $12
8010627b:	6a 0c                	push   $0xc
  jmp alltraps
8010627d:	e9 a4 fa ff ff       	jmp    80105d26 <alltraps>

80106282 <vector13>:
.globl vector13
vector13:
  pushl $13
80106282:	6a 0d                	push   $0xd
  jmp alltraps
80106284:	e9 9d fa ff ff       	jmp    80105d26 <alltraps>

80106289 <vector14>:
.globl vector14
vector14:
  pushl $14
80106289:	6a 0e                	push   $0xe
  jmp alltraps
8010628b:	e9 96 fa ff ff       	jmp    80105d26 <alltraps>

80106290 <vector15>:
.globl vector15
vector15:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $15
80106292:	6a 0f                	push   $0xf
  jmp alltraps
80106294:	e9 8d fa ff ff       	jmp    80105d26 <alltraps>

80106299 <vector16>:
.globl vector16
vector16:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $16
8010629b:	6a 10                	push   $0x10
  jmp alltraps
8010629d:	e9 84 fa ff ff       	jmp    80105d26 <alltraps>

801062a2 <vector17>:
.globl vector17
vector17:
  pushl $17
801062a2:	6a 11                	push   $0x11
  jmp alltraps
801062a4:	e9 7d fa ff ff       	jmp    80105d26 <alltraps>

801062a9 <vector18>:
.globl vector18
vector18:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $18
801062ab:	6a 12                	push   $0x12
  jmp alltraps
801062ad:	e9 74 fa ff ff       	jmp    80105d26 <alltraps>

801062b2 <vector19>:
.globl vector19
vector19:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $19
801062b4:	6a 13                	push   $0x13
  jmp alltraps
801062b6:	e9 6b fa ff ff       	jmp    80105d26 <alltraps>

801062bb <vector20>:
.globl vector20
vector20:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $20
801062bd:	6a 14                	push   $0x14
  jmp alltraps
801062bf:	e9 62 fa ff ff       	jmp    80105d26 <alltraps>

801062c4 <vector21>:
.globl vector21
vector21:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $21
801062c6:	6a 15                	push   $0x15
  jmp alltraps
801062c8:	e9 59 fa ff ff       	jmp    80105d26 <alltraps>

801062cd <vector22>:
.globl vector22
vector22:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $22
801062cf:	6a 16                	push   $0x16
  jmp alltraps
801062d1:	e9 50 fa ff ff       	jmp    80105d26 <alltraps>

801062d6 <vector23>:
.globl vector23
vector23:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $23
801062d8:	6a 17                	push   $0x17
  jmp alltraps
801062da:	e9 47 fa ff ff       	jmp    80105d26 <alltraps>

801062df <vector24>:
.globl vector24
vector24:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $24
801062e1:	6a 18                	push   $0x18
  jmp alltraps
801062e3:	e9 3e fa ff ff       	jmp    80105d26 <alltraps>

801062e8 <vector25>:
.globl vector25
vector25:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $25
801062ea:	6a 19                	push   $0x19
  jmp alltraps
801062ec:	e9 35 fa ff ff       	jmp    80105d26 <alltraps>

801062f1 <vector26>:
.globl vector26
vector26:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $26
801062f3:	6a 1a                	push   $0x1a
  jmp alltraps
801062f5:	e9 2c fa ff ff       	jmp    80105d26 <alltraps>

801062fa <vector27>:
.globl vector27
vector27:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $27
801062fc:	6a 1b                	push   $0x1b
  jmp alltraps
801062fe:	e9 23 fa ff ff       	jmp    80105d26 <alltraps>

80106303 <vector28>:
.globl vector28
vector28:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $28
80106305:	6a 1c                	push   $0x1c
  jmp alltraps
80106307:	e9 1a fa ff ff       	jmp    80105d26 <alltraps>

8010630c <vector29>:
.globl vector29
vector29:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $29
8010630e:	6a 1d                	push   $0x1d
  jmp alltraps
80106310:	e9 11 fa ff ff       	jmp    80105d26 <alltraps>

80106315 <vector30>:
.globl vector30
vector30:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $30
80106317:	6a 1e                	push   $0x1e
  jmp alltraps
80106319:	e9 08 fa ff ff       	jmp    80105d26 <alltraps>

8010631e <vector31>:
.globl vector31
vector31:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $31
80106320:	6a 1f                	push   $0x1f
  jmp alltraps
80106322:	e9 ff f9 ff ff       	jmp    80105d26 <alltraps>

80106327 <vector32>:
.globl vector32
vector32:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $32
80106329:	6a 20                	push   $0x20
  jmp alltraps
8010632b:	e9 f6 f9 ff ff       	jmp    80105d26 <alltraps>

80106330 <vector33>:
.globl vector33
vector33:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $33
80106332:	6a 21                	push   $0x21
  jmp alltraps
80106334:	e9 ed f9 ff ff       	jmp    80105d26 <alltraps>

80106339 <vector34>:
.globl vector34
vector34:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $34
8010633b:	6a 22                	push   $0x22
  jmp alltraps
8010633d:	e9 e4 f9 ff ff       	jmp    80105d26 <alltraps>

80106342 <vector35>:
.globl vector35
vector35:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $35
80106344:	6a 23                	push   $0x23
  jmp alltraps
80106346:	e9 db f9 ff ff       	jmp    80105d26 <alltraps>

8010634b <vector36>:
.globl vector36
vector36:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $36
8010634d:	6a 24                	push   $0x24
  jmp alltraps
8010634f:	e9 d2 f9 ff ff       	jmp    80105d26 <alltraps>

80106354 <vector37>:
.globl vector37
vector37:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $37
80106356:	6a 25                	push   $0x25
  jmp alltraps
80106358:	e9 c9 f9 ff ff       	jmp    80105d26 <alltraps>

8010635d <vector38>:
.globl vector38
vector38:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $38
8010635f:	6a 26                	push   $0x26
  jmp alltraps
80106361:	e9 c0 f9 ff ff       	jmp    80105d26 <alltraps>

80106366 <vector39>:
.globl vector39
vector39:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $39
80106368:	6a 27                	push   $0x27
  jmp alltraps
8010636a:	e9 b7 f9 ff ff       	jmp    80105d26 <alltraps>

8010636f <vector40>:
.globl vector40
vector40:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $40
80106371:	6a 28                	push   $0x28
  jmp alltraps
80106373:	e9 ae f9 ff ff       	jmp    80105d26 <alltraps>

80106378 <vector41>:
.globl vector41
vector41:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $41
8010637a:	6a 29                	push   $0x29
  jmp alltraps
8010637c:	e9 a5 f9 ff ff       	jmp    80105d26 <alltraps>

80106381 <vector42>:
.globl vector42
vector42:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $42
80106383:	6a 2a                	push   $0x2a
  jmp alltraps
80106385:	e9 9c f9 ff ff       	jmp    80105d26 <alltraps>

8010638a <vector43>:
.globl vector43
vector43:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $43
8010638c:	6a 2b                	push   $0x2b
  jmp alltraps
8010638e:	e9 93 f9 ff ff       	jmp    80105d26 <alltraps>

80106393 <vector44>:
.globl vector44
vector44:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $44
80106395:	6a 2c                	push   $0x2c
  jmp alltraps
80106397:	e9 8a f9 ff ff       	jmp    80105d26 <alltraps>

8010639c <vector45>:
.globl vector45
vector45:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $45
8010639e:	6a 2d                	push   $0x2d
  jmp alltraps
801063a0:	e9 81 f9 ff ff       	jmp    80105d26 <alltraps>

801063a5 <vector46>:
.globl vector46
vector46:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $46
801063a7:	6a 2e                	push   $0x2e
  jmp alltraps
801063a9:	e9 78 f9 ff ff       	jmp    80105d26 <alltraps>

801063ae <vector47>:
.globl vector47
vector47:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $47
801063b0:	6a 2f                	push   $0x2f
  jmp alltraps
801063b2:	e9 6f f9 ff ff       	jmp    80105d26 <alltraps>

801063b7 <vector48>:
.globl vector48
vector48:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $48
801063b9:	6a 30                	push   $0x30
  jmp alltraps
801063bb:	e9 66 f9 ff ff       	jmp    80105d26 <alltraps>

801063c0 <vector49>:
.globl vector49
vector49:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $49
801063c2:	6a 31                	push   $0x31
  jmp alltraps
801063c4:	e9 5d f9 ff ff       	jmp    80105d26 <alltraps>

801063c9 <vector50>:
.globl vector50
vector50:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $50
801063cb:	6a 32                	push   $0x32
  jmp alltraps
801063cd:	e9 54 f9 ff ff       	jmp    80105d26 <alltraps>

801063d2 <vector51>:
.globl vector51
vector51:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $51
801063d4:	6a 33                	push   $0x33
  jmp alltraps
801063d6:	e9 4b f9 ff ff       	jmp    80105d26 <alltraps>

801063db <vector52>:
.globl vector52
vector52:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $52
801063dd:	6a 34                	push   $0x34
  jmp alltraps
801063df:	e9 42 f9 ff ff       	jmp    80105d26 <alltraps>

801063e4 <vector53>:
.globl vector53
vector53:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $53
801063e6:	6a 35                	push   $0x35
  jmp alltraps
801063e8:	e9 39 f9 ff ff       	jmp    80105d26 <alltraps>

801063ed <vector54>:
.globl vector54
vector54:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $54
801063ef:	6a 36                	push   $0x36
  jmp alltraps
801063f1:	e9 30 f9 ff ff       	jmp    80105d26 <alltraps>

801063f6 <vector55>:
.globl vector55
vector55:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $55
801063f8:	6a 37                	push   $0x37
  jmp alltraps
801063fa:	e9 27 f9 ff ff       	jmp    80105d26 <alltraps>

801063ff <vector56>:
.globl vector56
vector56:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $56
80106401:	6a 38                	push   $0x38
  jmp alltraps
80106403:	e9 1e f9 ff ff       	jmp    80105d26 <alltraps>

80106408 <vector57>:
.globl vector57
vector57:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $57
8010640a:	6a 39                	push   $0x39
  jmp alltraps
8010640c:	e9 15 f9 ff ff       	jmp    80105d26 <alltraps>

80106411 <vector58>:
.globl vector58
vector58:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $58
80106413:	6a 3a                	push   $0x3a
  jmp alltraps
80106415:	e9 0c f9 ff ff       	jmp    80105d26 <alltraps>

8010641a <vector59>:
.globl vector59
vector59:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $59
8010641c:	6a 3b                	push   $0x3b
  jmp alltraps
8010641e:	e9 03 f9 ff ff       	jmp    80105d26 <alltraps>

80106423 <vector60>:
.globl vector60
vector60:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $60
80106425:	6a 3c                	push   $0x3c
  jmp alltraps
80106427:	e9 fa f8 ff ff       	jmp    80105d26 <alltraps>

8010642c <vector61>:
.globl vector61
vector61:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $61
8010642e:	6a 3d                	push   $0x3d
  jmp alltraps
80106430:	e9 f1 f8 ff ff       	jmp    80105d26 <alltraps>

80106435 <vector62>:
.globl vector62
vector62:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $62
80106437:	6a 3e                	push   $0x3e
  jmp alltraps
80106439:	e9 e8 f8 ff ff       	jmp    80105d26 <alltraps>

8010643e <vector63>:
.globl vector63
vector63:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $63
80106440:	6a 3f                	push   $0x3f
  jmp alltraps
80106442:	e9 df f8 ff ff       	jmp    80105d26 <alltraps>

80106447 <vector64>:
.globl vector64
vector64:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $64
80106449:	6a 40                	push   $0x40
  jmp alltraps
8010644b:	e9 d6 f8 ff ff       	jmp    80105d26 <alltraps>

80106450 <vector65>:
.globl vector65
vector65:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $65
80106452:	6a 41                	push   $0x41
  jmp alltraps
80106454:	e9 cd f8 ff ff       	jmp    80105d26 <alltraps>

80106459 <vector66>:
.globl vector66
vector66:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $66
8010645b:	6a 42                	push   $0x42
  jmp alltraps
8010645d:	e9 c4 f8 ff ff       	jmp    80105d26 <alltraps>

80106462 <vector67>:
.globl vector67
vector67:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $67
80106464:	6a 43                	push   $0x43
  jmp alltraps
80106466:	e9 bb f8 ff ff       	jmp    80105d26 <alltraps>

8010646b <vector68>:
.globl vector68
vector68:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $68
8010646d:	6a 44                	push   $0x44
  jmp alltraps
8010646f:	e9 b2 f8 ff ff       	jmp    80105d26 <alltraps>

80106474 <vector69>:
.globl vector69
vector69:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $69
80106476:	6a 45                	push   $0x45
  jmp alltraps
80106478:	e9 a9 f8 ff ff       	jmp    80105d26 <alltraps>

8010647d <vector70>:
.globl vector70
vector70:
  pushl $0
8010647d:	6a 00                	push   $0x0
  pushl $70
8010647f:	6a 46                	push   $0x46
  jmp alltraps
80106481:	e9 a0 f8 ff ff       	jmp    80105d26 <alltraps>

80106486 <vector71>:
.globl vector71
vector71:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $71
80106488:	6a 47                	push   $0x47
  jmp alltraps
8010648a:	e9 97 f8 ff ff       	jmp    80105d26 <alltraps>

8010648f <vector72>:
.globl vector72
vector72:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $72
80106491:	6a 48                	push   $0x48
  jmp alltraps
80106493:	e9 8e f8 ff ff       	jmp    80105d26 <alltraps>

80106498 <vector73>:
.globl vector73
vector73:
  pushl $0
80106498:	6a 00                	push   $0x0
  pushl $73
8010649a:	6a 49                	push   $0x49
  jmp alltraps
8010649c:	e9 85 f8 ff ff       	jmp    80105d26 <alltraps>

801064a1 <vector74>:
.globl vector74
vector74:
  pushl $0
801064a1:	6a 00                	push   $0x0
  pushl $74
801064a3:	6a 4a                	push   $0x4a
  jmp alltraps
801064a5:	e9 7c f8 ff ff       	jmp    80105d26 <alltraps>

801064aa <vector75>:
.globl vector75
vector75:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $75
801064ac:	6a 4b                	push   $0x4b
  jmp alltraps
801064ae:	e9 73 f8 ff ff       	jmp    80105d26 <alltraps>

801064b3 <vector76>:
.globl vector76
vector76:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $76
801064b5:	6a 4c                	push   $0x4c
  jmp alltraps
801064b7:	e9 6a f8 ff ff       	jmp    80105d26 <alltraps>

801064bc <vector77>:
.globl vector77
vector77:
  pushl $0
801064bc:	6a 00                	push   $0x0
  pushl $77
801064be:	6a 4d                	push   $0x4d
  jmp alltraps
801064c0:	e9 61 f8 ff ff       	jmp    80105d26 <alltraps>

801064c5 <vector78>:
.globl vector78
vector78:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $78
801064c7:	6a 4e                	push   $0x4e
  jmp alltraps
801064c9:	e9 58 f8 ff ff       	jmp    80105d26 <alltraps>

801064ce <vector79>:
.globl vector79
vector79:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $79
801064d0:	6a 4f                	push   $0x4f
  jmp alltraps
801064d2:	e9 4f f8 ff ff       	jmp    80105d26 <alltraps>

801064d7 <vector80>:
.globl vector80
vector80:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $80
801064d9:	6a 50                	push   $0x50
  jmp alltraps
801064db:	e9 46 f8 ff ff       	jmp    80105d26 <alltraps>

801064e0 <vector81>:
.globl vector81
vector81:
  pushl $0
801064e0:	6a 00                	push   $0x0
  pushl $81
801064e2:	6a 51                	push   $0x51
  jmp alltraps
801064e4:	e9 3d f8 ff ff       	jmp    80105d26 <alltraps>

801064e9 <vector82>:
.globl vector82
vector82:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $82
801064eb:	6a 52                	push   $0x52
  jmp alltraps
801064ed:	e9 34 f8 ff ff       	jmp    80105d26 <alltraps>

801064f2 <vector83>:
.globl vector83
vector83:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $83
801064f4:	6a 53                	push   $0x53
  jmp alltraps
801064f6:	e9 2b f8 ff ff       	jmp    80105d26 <alltraps>

801064fb <vector84>:
.globl vector84
vector84:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $84
801064fd:	6a 54                	push   $0x54
  jmp alltraps
801064ff:	e9 22 f8 ff ff       	jmp    80105d26 <alltraps>

80106504 <vector85>:
.globl vector85
vector85:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $85
80106506:	6a 55                	push   $0x55
  jmp alltraps
80106508:	e9 19 f8 ff ff       	jmp    80105d26 <alltraps>

8010650d <vector86>:
.globl vector86
vector86:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $86
8010650f:	6a 56                	push   $0x56
  jmp alltraps
80106511:	e9 10 f8 ff ff       	jmp    80105d26 <alltraps>

80106516 <vector87>:
.globl vector87
vector87:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $87
80106518:	6a 57                	push   $0x57
  jmp alltraps
8010651a:	e9 07 f8 ff ff       	jmp    80105d26 <alltraps>

8010651f <vector88>:
.globl vector88
vector88:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $88
80106521:	6a 58                	push   $0x58
  jmp alltraps
80106523:	e9 fe f7 ff ff       	jmp    80105d26 <alltraps>

80106528 <vector89>:
.globl vector89
vector89:
  pushl $0
80106528:	6a 00                	push   $0x0
  pushl $89
8010652a:	6a 59                	push   $0x59
  jmp alltraps
8010652c:	e9 f5 f7 ff ff       	jmp    80105d26 <alltraps>

80106531 <vector90>:
.globl vector90
vector90:
  pushl $0
80106531:	6a 00                	push   $0x0
  pushl $90
80106533:	6a 5a                	push   $0x5a
  jmp alltraps
80106535:	e9 ec f7 ff ff       	jmp    80105d26 <alltraps>

8010653a <vector91>:
.globl vector91
vector91:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $91
8010653c:	6a 5b                	push   $0x5b
  jmp alltraps
8010653e:	e9 e3 f7 ff ff       	jmp    80105d26 <alltraps>

80106543 <vector92>:
.globl vector92
vector92:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $92
80106545:	6a 5c                	push   $0x5c
  jmp alltraps
80106547:	e9 da f7 ff ff       	jmp    80105d26 <alltraps>

8010654c <vector93>:
.globl vector93
vector93:
  pushl $0
8010654c:	6a 00                	push   $0x0
  pushl $93
8010654e:	6a 5d                	push   $0x5d
  jmp alltraps
80106550:	e9 d1 f7 ff ff       	jmp    80105d26 <alltraps>

80106555 <vector94>:
.globl vector94
vector94:
  pushl $0
80106555:	6a 00                	push   $0x0
  pushl $94
80106557:	6a 5e                	push   $0x5e
  jmp alltraps
80106559:	e9 c8 f7 ff ff       	jmp    80105d26 <alltraps>

8010655e <vector95>:
.globl vector95
vector95:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $95
80106560:	6a 5f                	push   $0x5f
  jmp alltraps
80106562:	e9 bf f7 ff ff       	jmp    80105d26 <alltraps>

80106567 <vector96>:
.globl vector96
vector96:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $96
80106569:	6a 60                	push   $0x60
  jmp alltraps
8010656b:	e9 b6 f7 ff ff       	jmp    80105d26 <alltraps>

80106570 <vector97>:
.globl vector97
vector97:
  pushl $0
80106570:	6a 00                	push   $0x0
  pushl $97
80106572:	6a 61                	push   $0x61
  jmp alltraps
80106574:	e9 ad f7 ff ff       	jmp    80105d26 <alltraps>

80106579 <vector98>:
.globl vector98
vector98:
  pushl $0
80106579:	6a 00                	push   $0x0
  pushl $98
8010657b:	6a 62                	push   $0x62
  jmp alltraps
8010657d:	e9 a4 f7 ff ff       	jmp    80105d26 <alltraps>

80106582 <vector99>:
.globl vector99
vector99:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $99
80106584:	6a 63                	push   $0x63
  jmp alltraps
80106586:	e9 9b f7 ff ff       	jmp    80105d26 <alltraps>

8010658b <vector100>:
.globl vector100
vector100:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $100
8010658d:	6a 64                	push   $0x64
  jmp alltraps
8010658f:	e9 92 f7 ff ff       	jmp    80105d26 <alltraps>

80106594 <vector101>:
.globl vector101
vector101:
  pushl $0
80106594:	6a 00                	push   $0x0
  pushl $101
80106596:	6a 65                	push   $0x65
  jmp alltraps
80106598:	e9 89 f7 ff ff       	jmp    80105d26 <alltraps>

8010659d <vector102>:
.globl vector102
vector102:
  pushl $0
8010659d:	6a 00                	push   $0x0
  pushl $102
8010659f:	6a 66                	push   $0x66
  jmp alltraps
801065a1:	e9 80 f7 ff ff       	jmp    80105d26 <alltraps>

801065a6 <vector103>:
.globl vector103
vector103:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $103
801065a8:	6a 67                	push   $0x67
  jmp alltraps
801065aa:	e9 77 f7 ff ff       	jmp    80105d26 <alltraps>

801065af <vector104>:
.globl vector104
vector104:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $104
801065b1:	6a 68                	push   $0x68
  jmp alltraps
801065b3:	e9 6e f7 ff ff       	jmp    80105d26 <alltraps>

801065b8 <vector105>:
.globl vector105
vector105:
  pushl $0
801065b8:	6a 00                	push   $0x0
  pushl $105
801065ba:	6a 69                	push   $0x69
  jmp alltraps
801065bc:	e9 65 f7 ff ff       	jmp    80105d26 <alltraps>

801065c1 <vector106>:
.globl vector106
vector106:
  pushl $0
801065c1:	6a 00                	push   $0x0
  pushl $106
801065c3:	6a 6a                	push   $0x6a
  jmp alltraps
801065c5:	e9 5c f7 ff ff       	jmp    80105d26 <alltraps>

801065ca <vector107>:
.globl vector107
vector107:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $107
801065cc:	6a 6b                	push   $0x6b
  jmp alltraps
801065ce:	e9 53 f7 ff ff       	jmp    80105d26 <alltraps>

801065d3 <vector108>:
.globl vector108
vector108:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $108
801065d5:	6a 6c                	push   $0x6c
  jmp alltraps
801065d7:	e9 4a f7 ff ff       	jmp    80105d26 <alltraps>

801065dc <vector109>:
.globl vector109
vector109:
  pushl $0
801065dc:	6a 00                	push   $0x0
  pushl $109
801065de:	6a 6d                	push   $0x6d
  jmp alltraps
801065e0:	e9 41 f7 ff ff       	jmp    80105d26 <alltraps>

801065e5 <vector110>:
.globl vector110
vector110:
  pushl $0
801065e5:	6a 00                	push   $0x0
  pushl $110
801065e7:	6a 6e                	push   $0x6e
  jmp alltraps
801065e9:	e9 38 f7 ff ff       	jmp    80105d26 <alltraps>

801065ee <vector111>:
.globl vector111
vector111:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $111
801065f0:	6a 6f                	push   $0x6f
  jmp alltraps
801065f2:	e9 2f f7 ff ff       	jmp    80105d26 <alltraps>

801065f7 <vector112>:
.globl vector112
vector112:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $112
801065f9:	6a 70                	push   $0x70
  jmp alltraps
801065fb:	e9 26 f7 ff ff       	jmp    80105d26 <alltraps>

80106600 <vector113>:
.globl vector113
vector113:
  pushl $0
80106600:	6a 00                	push   $0x0
  pushl $113
80106602:	6a 71                	push   $0x71
  jmp alltraps
80106604:	e9 1d f7 ff ff       	jmp    80105d26 <alltraps>

80106609 <vector114>:
.globl vector114
vector114:
  pushl $0
80106609:	6a 00                	push   $0x0
  pushl $114
8010660b:	6a 72                	push   $0x72
  jmp alltraps
8010660d:	e9 14 f7 ff ff       	jmp    80105d26 <alltraps>

80106612 <vector115>:
.globl vector115
vector115:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $115
80106614:	6a 73                	push   $0x73
  jmp alltraps
80106616:	e9 0b f7 ff ff       	jmp    80105d26 <alltraps>

8010661b <vector116>:
.globl vector116
vector116:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $116
8010661d:	6a 74                	push   $0x74
  jmp alltraps
8010661f:	e9 02 f7 ff ff       	jmp    80105d26 <alltraps>

80106624 <vector117>:
.globl vector117
vector117:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $117
80106626:	6a 75                	push   $0x75
  jmp alltraps
80106628:	e9 f9 f6 ff ff       	jmp    80105d26 <alltraps>

8010662d <vector118>:
.globl vector118
vector118:
  pushl $0
8010662d:	6a 00                	push   $0x0
  pushl $118
8010662f:	6a 76                	push   $0x76
  jmp alltraps
80106631:	e9 f0 f6 ff ff       	jmp    80105d26 <alltraps>

80106636 <vector119>:
.globl vector119
vector119:
  pushl $0
80106636:	6a 00                	push   $0x0
  pushl $119
80106638:	6a 77                	push   $0x77
  jmp alltraps
8010663a:	e9 e7 f6 ff ff       	jmp    80105d26 <alltraps>

8010663f <vector120>:
.globl vector120
vector120:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $120
80106641:	6a 78                	push   $0x78
  jmp alltraps
80106643:	e9 de f6 ff ff       	jmp    80105d26 <alltraps>

80106648 <vector121>:
.globl vector121
vector121:
  pushl $0
80106648:	6a 00                	push   $0x0
  pushl $121
8010664a:	6a 79                	push   $0x79
  jmp alltraps
8010664c:	e9 d5 f6 ff ff       	jmp    80105d26 <alltraps>

80106651 <vector122>:
.globl vector122
vector122:
  pushl $0
80106651:	6a 00                	push   $0x0
  pushl $122
80106653:	6a 7a                	push   $0x7a
  jmp alltraps
80106655:	e9 cc f6 ff ff       	jmp    80105d26 <alltraps>

8010665a <vector123>:
.globl vector123
vector123:
  pushl $0
8010665a:	6a 00                	push   $0x0
  pushl $123
8010665c:	6a 7b                	push   $0x7b
  jmp alltraps
8010665e:	e9 c3 f6 ff ff       	jmp    80105d26 <alltraps>

80106663 <vector124>:
.globl vector124
vector124:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $124
80106665:	6a 7c                	push   $0x7c
  jmp alltraps
80106667:	e9 ba f6 ff ff       	jmp    80105d26 <alltraps>

8010666c <vector125>:
.globl vector125
vector125:
  pushl $0
8010666c:	6a 00                	push   $0x0
  pushl $125
8010666e:	6a 7d                	push   $0x7d
  jmp alltraps
80106670:	e9 b1 f6 ff ff       	jmp    80105d26 <alltraps>

80106675 <vector126>:
.globl vector126
vector126:
  pushl $0
80106675:	6a 00                	push   $0x0
  pushl $126
80106677:	6a 7e                	push   $0x7e
  jmp alltraps
80106679:	e9 a8 f6 ff ff       	jmp    80105d26 <alltraps>

8010667e <vector127>:
.globl vector127
vector127:
  pushl $0
8010667e:	6a 00                	push   $0x0
  pushl $127
80106680:	6a 7f                	push   $0x7f
  jmp alltraps
80106682:	e9 9f f6 ff ff       	jmp    80105d26 <alltraps>

80106687 <vector128>:
.globl vector128
vector128:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $128
80106689:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010668e:	e9 93 f6 ff ff       	jmp    80105d26 <alltraps>

80106693 <vector129>:
.globl vector129
vector129:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $129
80106695:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010669a:	e9 87 f6 ff ff       	jmp    80105d26 <alltraps>

8010669f <vector130>:
.globl vector130
vector130:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $130
801066a1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801066a6:	e9 7b f6 ff ff       	jmp    80105d26 <alltraps>

801066ab <vector131>:
.globl vector131
vector131:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $131
801066ad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801066b2:	e9 6f f6 ff ff       	jmp    80105d26 <alltraps>

801066b7 <vector132>:
.globl vector132
vector132:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $132
801066b9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801066be:	e9 63 f6 ff ff       	jmp    80105d26 <alltraps>

801066c3 <vector133>:
.globl vector133
vector133:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $133
801066c5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801066ca:	e9 57 f6 ff ff       	jmp    80105d26 <alltraps>

801066cf <vector134>:
.globl vector134
vector134:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $134
801066d1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801066d6:	e9 4b f6 ff ff       	jmp    80105d26 <alltraps>

801066db <vector135>:
.globl vector135
vector135:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $135
801066dd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801066e2:	e9 3f f6 ff ff       	jmp    80105d26 <alltraps>

801066e7 <vector136>:
.globl vector136
vector136:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $136
801066e9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801066ee:	e9 33 f6 ff ff       	jmp    80105d26 <alltraps>

801066f3 <vector137>:
.globl vector137
vector137:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $137
801066f5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801066fa:	e9 27 f6 ff ff       	jmp    80105d26 <alltraps>

801066ff <vector138>:
.globl vector138
vector138:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $138
80106701:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106706:	e9 1b f6 ff ff       	jmp    80105d26 <alltraps>

8010670b <vector139>:
.globl vector139
vector139:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $139
8010670d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106712:	e9 0f f6 ff ff       	jmp    80105d26 <alltraps>

80106717 <vector140>:
.globl vector140
vector140:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $140
80106719:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010671e:	e9 03 f6 ff ff       	jmp    80105d26 <alltraps>

80106723 <vector141>:
.globl vector141
vector141:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $141
80106725:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010672a:	e9 f7 f5 ff ff       	jmp    80105d26 <alltraps>

8010672f <vector142>:
.globl vector142
vector142:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $142
80106731:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106736:	e9 eb f5 ff ff       	jmp    80105d26 <alltraps>

8010673b <vector143>:
.globl vector143
vector143:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $143
8010673d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106742:	e9 df f5 ff ff       	jmp    80105d26 <alltraps>

80106747 <vector144>:
.globl vector144
vector144:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $144
80106749:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010674e:	e9 d3 f5 ff ff       	jmp    80105d26 <alltraps>

80106753 <vector145>:
.globl vector145
vector145:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $145
80106755:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010675a:	e9 c7 f5 ff ff       	jmp    80105d26 <alltraps>

8010675f <vector146>:
.globl vector146
vector146:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $146
80106761:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106766:	e9 bb f5 ff ff       	jmp    80105d26 <alltraps>

8010676b <vector147>:
.globl vector147
vector147:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $147
8010676d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106772:	e9 af f5 ff ff       	jmp    80105d26 <alltraps>

80106777 <vector148>:
.globl vector148
vector148:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $148
80106779:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010677e:	e9 a3 f5 ff ff       	jmp    80105d26 <alltraps>

80106783 <vector149>:
.globl vector149
vector149:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $149
80106785:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010678a:	e9 97 f5 ff ff       	jmp    80105d26 <alltraps>

8010678f <vector150>:
.globl vector150
vector150:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $150
80106791:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106796:	e9 8b f5 ff ff       	jmp    80105d26 <alltraps>

8010679b <vector151>:
.globl vector151
vector151:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $151
8010679d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801067a2:	e9 7f f5 ff ff       	jmp    80105d26 <alltraps>

801067a7 <vector152>:
.globl vector152
vector152:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $152
801067a9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801067ae:	e9 73 f5 ff ff       	jmp    80105d26 <alltraps>

801067b3 <vector153>:
.globl vector153
vector153:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $153
801067b5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801067ba:	e9 67 f5 ff ff       	jmp    80105d26 <alltraps>

801067bf <vector154>:
.globl vector154
vector154:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $154
801067c1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801067c6:	e9 5b f5 ff ff       	jmp    80105d26 <alltraps>

801067cb <vector155>:
.globl vector155
vector155:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $155
801067cd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801067d2:	e9 4f f5 ff ff       	jmp    80105d26 <alltraps>

801067d7 <vector156>:
.globl vector156
vector156:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $156
801067d9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801067de:	e9 43 f5 ff ff       	jmp    80105d26 <alltraps>

801067e3 <vector157>:
.globl vector157
vector157:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $157
801067e5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801067ea:	e9 37 f5 ff ff       	jmp    80105d26 <alltraps>

801067ef <vector158>:
.globl vector158
vector158:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $158
801067f1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801067f6:	e9 2b f5 ff ff       	jmp    80105d26 <alltraps>

801067fb <vector159>:
.globl vector159
vector159:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $159
801067fd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106802:	e9 1f f5 ff ff       	jmp    80105d26 <alltraps>

80106807 <vector160>:
.globl vector160
vector160:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $160
80106809:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010680e:	e9 13 f5 ff ff       	jmp    80105d26 <alltraps>

80106813 <vector161>:
.globl vector161
vector161:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $161
80106815:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010681a:	e9 07 f5 ff ff       	jmp    80105d26 <alltraps>

8010681f <vector162>:
.globl vector162
vector162:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $162
80106821:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106826:	e9 fb f4 ff ff       	jmp    80105d26 <alltraps>

8010682b <vector163>:
.globl vector163
vector163:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $163
8010682d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106832:	e9 ef f4 ff ff       	jmp    80105d26 <alltraps>

80106837 <vector164>:
.globl vector164
vector164:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $164
80106839:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010683e:	e9 e3 f4 ff ff       	jmp    80105d26 <alltraps>

80106843 <vector165>:
.globl vector165
vector165:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $165
80106845:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010684a:	e9 d7 f4 ff ff       	jmp    80105d26 <alltraps>

8010684f <vector166>:
.globl vector166
vector166:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $166
80106851:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106856:	e9 cb f4 ff ff       	jmp    80105d26 <alltraps>

8010685b <vector167>:
.globl vector167
vector167:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $167
8010685d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106862:	e9 bf f4 ff ff       	jmp    80105d26 <alltraps>

80106867 <vector168>:
.globl vector168
vector168:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $168
80106869:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010686e:	e9 b3 f4 ff ff       	jmp    80105d26 <alltraps>

80106873 <vector169>:
.globl vector169
vector169:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $169
80106875:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010687a:	e9 a7 f4 ff ff       	jmp    80105d26 <alltraps>

8010687f <vector170>:
.globl vector170
vector170:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $170
80106881:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106886:	e9 9b f4 ff ff       	jmp    80105d26 <alltraps>

8010688b <vector171>:
.globl vector171
vector171:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $171
8010688d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106892:	e9 8f f4 ff ff       	jmp    80105d26 <alltraps>

80106897 <vector172>:
.globl vector172
vector172:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $172
80106899:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010689e:	e9 83 f4 ff ff       	jmp    80105d26 <alltraps>

801068a3 <vector173>:
.globl vector173
vector173:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $173
801068a5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801068aa:	e9 77 f4 ff ff       	jmp    80105d26 <alltraps>

801068af <vector174>:
.globl vector174
vector174:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $174
801068b1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801068b6:	e9 6b f4 ff ff       	jmp    80105d26 <alltraps>

801068bb <vector175>:
.globl vector175
vector175:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $175
801068bd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801068c2:	e9 5f f4 ff ff       	jmp    80105d26 <alltraps>

801068c7 <vector176>:
.globl vector176
vector176:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $176
801068c9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801068ce:	e9 53 f4 ff ff       	jmp    80105d26 <alltraps>

801068d3 <vector177>:
.globl vector177
vector177:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $177
801068d5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801068da:	e9 47 f4 ff ff       	jmp    80105d26 <alltraps>

801068df <vector178>:
.globl vector178
vector178:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $178
801068e1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801068e6:	e9 3b f4 ff ff       	jmp    80105d26 <alltraps>

801068eb <vector179>:
.globl vector179
vector179:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $179
801068ed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801068f2:	e9 2f f4 ff ff       	jmp    80105d26 <alltraps>

801068f7 <vector180>:
.globl vector180
vector180:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $180
801068f9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801068fe:	e9 23 f4 ff ff       	jmp    80105d26 <alltraps>

80106903 <vector181>:
.globl vector181
vector181:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $181
80106905:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010690a:	e9 17 f4 ff ff       	jmp    80105d26 <alltraps>

8010690f <vector182>:
.globl vector182
vector182:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $182
80106911:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106916:	e9 0b f4 ff ff       	jmp    80105d26 <alltraps>

8010691b <vector183>:
.globl vector183
vector183:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $183
8010691d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106922:	e9 ff f3 ff ff       	jmp    80105d26 <alltraps>

80106927 <vector184>:
.globl vector184
vector184:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $184
80106929:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010692e:	e9 f3 f3 ff ff       	jmp    80105d26 <alltraps>

80106933 <vector185>:
.globl vector185
vector185:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $185
80106935:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010693a:	e9 e7 f3 ff ff       	jmp    80105d26 <alltraps>

8010693f <vector186>:
.globl vector186
vector186:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $186
80106941:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106946:	e9 db f3 ff ff       	jmp    80105d26 <alltraps>

8010694b <vector187>:
.globl vector187
vector187:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $187
8010694d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106952:	e9 cf f3 ff ff       	jmp    80105d26 <alltraps>

80106957 <vector188>:
.globl vector188
vector188:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $188
80106959:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010695e:	e9 c3 f3 ff ff       	jmp    80105d26 <alltraps>

80106963 <vector189>:
.globl vector189
vector189:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $189
80106965:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010696a:	e9 b7 f3 ff ff       	jmp    80105d26 <alltraps>

8010696f <vector190>:
.globl vector190
vector190:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $190
80106971:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106976:	e9 ab f3 ff ff       	jmp    80105d26 <alltraps>

8010697b <vector191>:
.globl vector191
vector191:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $191
8010697d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106982:	e9 9f f3 ff ff       	jmp    80105d26 <alltraps>

80106987 <vector192>:
.globl vector192
vector192:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $192
80106989:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010698e:	e9 93 f3 ff ff       	jmp    80105d26 <alltraps>

80106993 <vector193>:
.globl vector193
vector193:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $193
80106995:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010699a:	e9 87 f3 ff ff       	jmp    80105d26 <alltraps>

8010699f <vector194>:
.globl vector194
vector194:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $194
801069a1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801069a6:	e9 7b f3 ff ff       	jmp    80105d26 <alltraps>

801069ab <vector195>:
.globl vector195
vector195:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $195
801069ad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801069b2:	e9 6f f3 ff ff       	jmp    80105d26 <alltraps>

801069b7 <vector196>:
.globl vector196
vector196:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $196
801069b9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801069be:	e9 63 f3 ff ff       	jmp    80105d26 <alltraps>

801069c3 <vector197>:
.globl vector197
vector197:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $197
801069c5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801069ca:	e9 57 f3 ff ff       	jmp    80105d26 <alltraps>

801069cf <vector198>:
.globl vector198
vector198:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $198
801069d1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801069d6:	e9 4b f3 ff ff       	jmp    80105d26 <alltraps>

801069db <vector199>:
.globl vector199
vector199:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $199
801069dd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801069e2:	e9 3f f3 ff ff       	jmp    80105d26 <alltraps>

801069e7 <vector200>:
.globl vector200
vector200:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $200
801069e9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801069ee:	e9 33 f3 ff ff       	jmp    80105d26 <alltraps>

801069f3 <vector201>:
.globl vector201
vector201:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $201
801069f5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801069fa:	e9 27 f3 ff ff       	jmp    80105d26 <alltraps>

801069ff <vector202>:
.globl vector202
vector202:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $202
80106a01:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a06:	e9 1b f3 ff ff       	jmp    80105d26 <alltraps>

80106a0b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $203
80106a0d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a12:	e9 0f f3 ff ff       	jmp    80105d26 <alltraps>

80106a17 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $204
80106a19:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a1e:	e9 03 f3 ff ff       	jmp    80105d26 <alltraps>

80106a23 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $205
80106a25:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a2a:	e9 f7 f2 ff ff       	jmp    80105d26 <alltraps>

80106a2f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $206
80106a31:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a36:	e9 eb f2 ff ff       	jmp    80105d26 <alltraps>

80106a3b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $207
80106a3d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a42:	e9 df f2 ff ff       	jmp    80105d26 <alltraps>

80106a47 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $208
80106a49:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a4e:	e9 d3 f2 ff ff       	jmp    80105d26 <alltraps>

80106a53 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $209
80106a55:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a5a:	e9 c7 f2 ff ff       	jmp    80105d26 <alltraps>

80106a5f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $210
80106a61:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a66:	e9 bb f2 ff ff       	jmp    80105d26 <alltraps>

80106a6b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $211
80106a6d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a72:	e9 af f2 ff ff       	jmp    80105d26 <alltraps>

80106a77 <vector212>:
.globl vector212
vector212:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $212
80106a79:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a7e:	e9 a3 f2 ff ff       	jmp    80105d26 <alltraps>

80106a83 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $213
80106a85:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a8a:	e9 97 f2 ff ff       	jmp    80105d26 <alltraps>

80106a8f <vector214>:
.globl vector214
vector214:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $214
80106a91:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a96:	e9 8b f2 ff ff       	jmp    80105d26 <alltraps>

80106a9b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $215
80106a9d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106aa2:	e9 7f f2 ff ff       	jmp    80105d26 <alltraps>

80106aa7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $216
80106aa9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106aae:	e9 73 f2 ff ff       	jmp    80105d26 <alltraps>

80106ab3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $217
80106ab5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106aba:	e9 67 f2 ff ff       	jmp    80105d26 <alltraps>

80106abf <vector218>:
.globl vector218
vector218:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $218
80106ac1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ac6:	e9 5b f2 ff ff       	jmp    80105d26 <alltraps>

80106acb <vector219>:
.globl vector219
vector219:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $219
80106acd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ad2:	e9 4f f2 ff ff       	jmp    80105d26 <alltraps>

80106ad7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $220
80106ad9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ade:	e9 43 f2 ff ff       	jmp    80105d26 <alltraps>

80106ae3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $221
80106ae5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106aea:	e9 37 f2 ff ff       	jmp    80105d26 <alltraps>

80106aef <vector222>:
.globl vector222
vector222:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $222
80106af1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106af6:	e9 2b f2 ff ff       	jmp    80105d26 <alltraps>

80106afb <vector223>:
.globl vector223
vector223:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $223
80106afd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b02:	e9 1f f2 ff ff       	jmp    80105d26 <alltraps>

80106b07 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $224
80106b09:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b0e:	e9 13 f2 ff ff       	jmp    80105d26 <alltraps>

80106b13 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $225
80106b15:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b1a:	e9 07 f2 ff ff       	jmp    80105d26 <alltraps>

80106b1f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $226
80106b21:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b26:	e9 fb f1 ff ff       	jmp    80105d26 <alltraps>

80106b2b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $227
80106b2d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b32:	e9 ef f1 ff ff       	jmp    80105d26 <alltraps>

80106b37 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $228
80106b39:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b3e:	e9 e3 f1 ff ff       	jmp    80105d26 <alltraps>

80106b43 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $229
80106b45:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b4a:	e9 d7 f1 ff ff       	jmp    80105d26 <alltraps>

80106b4f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $230
80106b51:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b56:	e9 cb f1 ff ff       	jmp    80105d26 <alltraps>

80106b5b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $231
80106b5d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b62:	e9 bf f1 ff ff       	jmp    80105d26 <alltraps>

80106b67 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $232
80106b69:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b6e:	e9 b3 f1 ff ff       	jmp    80105d26 <alltraps>

80106b73 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $233
80106b75:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b7a:	e9 a7 f1 ff ff       	jmp    80105d26 <alltraps>

80106b7f <vector234>:
.globl vector234
vector234:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $234
80106b81:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b86:	e9 9b f1 ff ff       	jmp    80105d26 <alltraps>

80106b8b <vector235>:
.globl vector235
vector235:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $235
80106b8d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b92:	e9 8f f1 ff ff       	jmp    80105d26 <alltraps>

80106b97 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $236
80106b99:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b9e:	e9 83 f1 ff ff       	jmp    80105d26 <alltraps>

80106ba3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $237
80106ba5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106baa:	e9 77 f1 ff ff       	jmp    80105d26 <alltraps>

80106baf <vector238>:
.globl vector238
vector238:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $238
80106bb1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106bb6:	e9 6b f1 ff ff       	jmp    80105d26 <alltraps>

80106bbb <vector239>:
.globl vector239
vector239:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $239
80106bbd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106bc2:	e9 5f f1 ff ff       	jmp    80105d26 <alltraps>

80106bc7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $240
80106bc9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106bce:	e9 53 f1 ff ff       	jmp    80105d26 <alltraps>

80106bd3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $241
80106bd5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106bda:	e9 47 f1 ff ff       	jmp    80105d26 <alltraps>

80106bdf <vector242>:
.globl vector242
vector242:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $242
80106be1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106be6:	e9 3b f1 ff ff       	jmp    80105d26 <alltraps>

80106beb <vector243>:
.globl vector243
vector243:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $243
80106bed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106bf2:	e9 2f f1 ff ff       	jmp    80105d26 <alltraps>

80106bf7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $244
80106bf9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106bfe:	e9 23 f1 ff ff       	jmp    80105d26 <alltraps>

80106c03 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $245
80106c05:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c0a:	e9 17 f1 ff ff       	jmp    80105d26 <alltraps>

80106c0f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $246
80106c11:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c16:	e9 0b f1 ff ff       	jmp    80105d26 <alltraps>

80106c1b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $247
80106c1d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c22:	e9 ff f0 ff ff       	jmp    80105d26 <alltraps>

80106c27 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $248
80106c29:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c2e:	e9 f3 f0 ff ff       	jmp    80105d26 <alltraps>

80106c33 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $249
80106c35:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c3a:	e9 e7 f0 ff ff       	jmp    80105d26 <alltraps>

80106c3f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $250
80106c41:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c46:	e9 db f0 ff ff       	jmp    80105d26 <alltraps>

80106c4b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $251
80106c4d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c52:	e9 cf f0 ff ff       	jmp    80105d26 <alltraps>

80106c57 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $252
80106c59:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c5e:	e9 c3 f0 ff ff       	jmp    80105d26 <alltraps>

80106c63 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $253
80106c65:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c6a:	e9 b7 f0 ff ff       	jmp    80105d26 <alltraps>

80106c6f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $254
80106c71:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c76:	e9 ab f0 ff ff       	jmp    80105d26 <alltraps>

80106c7b <vector255>:
.globl vector255
vector255:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $255
80106c7d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c82:	e9 9f f0 ff ff       	jmp    80105d26 <alltraps>
80106c87:	66 90                	xchg   %ax,%ax
80106c89:	66 90                	xchg   %ax,%ax
80106c8b:	66 90                	xchg   %ax,%ax
80106c8d:	66 90                	xchg   %ax,%ax
80106c8f:	90                   	nop

80106c90 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	57                   	push   %edi
80106c94:	56                   	push   %esi
80106c95:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c96:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106c9c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ca2:	83 ec 1c             	sub    $0x1c,%esp
80106ca5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106ca8:	39 d3                	cmp    %edx,%ebx
80106caa:	73 49                	jae    80106cf5 <deallocuvm.part.0+0x65>
80106cac:	89 c7                	mov    %eax,%edi
80106cae:	eb 0c                	jmp    80106cbc <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106cb0:	83 c0 01             	add    $0x1,%eax
80106cb3:	c1 e0 16             	shl    $0x16,%eax
80106cb6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106cb8:	39 da                	cmp    %ebx,%edx
80106cba:	76 39                	jbe    80106cf5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106cbc:	89 d8                	mov    %ebx,%eax
80106cbe:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106cc1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106cc4:	f6 c1 01             	test   $0x1,%cl
80106cc7:	74 e7                	je     80106cb0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106cc9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ccb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106cd1:	c1 ee 0a             	shr    $0xa,%esi
80106cd4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106cda:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106ce1:	85 f6                	test   %esi,%esi
80106ce3:	74 cb                	je     80106cb0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106ce5:	8b 06                	mov    (%esi),%eax
80106ce7:	a8 01                	test   $0x1,%al
80106ce9:	75 15                	jne    80106d00 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106ceb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cf1:	39 da                	cmp    %ebx,%edx
80106cf3:	77 c7                	ja     80106cbc <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106cf5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cfb:	5b                   	pop    %ebx
80106cfc:	5e                   	pop    %esi
80106cfd:	5f                   	pop    %edi
80106cfe:	5d                   	pop    %ebp
80106cff:	c3                   	ret    
      if(pa == 0)
80106d00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d05:	74 25                	je     80106d2c <deallocuvm.part.0+0x9c>
      kfree(v);
80106d07:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d0a:	05 00 00 00 80       	add    $0x80000000,%eax
80106d0f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d12:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106d18:	50                   	push   %eax
80106d19:	e8 a2 b7 ff ff       	call   801024c0 <kfree>
      *pte = 0;
80106d1e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106d24:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106d27:	83 c4 10             	add    $0x10,%esp
80106d2a:	eb 8c                	jmp    80106cb8 <deallocuvm.part.0+0x28>
        panic("kfree");
80106d2c:	83 ec 0c             	sub    $0xc,%esp
80106d2f:	68 e6 78 10 80       	push   $0x801078e6
80106d34:	e8 47 96 ff ff       	call   80100380 <panic>
80106d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d40 <mappages>:
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	57                   	push   %edi
80106d44:	56                   	push   %esi
80106d45:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106d46:	89 d3                	mov    %edx,%ebx
80106d48:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106d4e:	83 ec 1c             	sub    $0x1c,%esp
80106d51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d54:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d5d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d60:	8b 45 08             	mov    0x8(%ebp),%eax
80106d63:	29 d8                	sub    %ebx,%eax
80106d65:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d68:	eb 3d                	jmp    80106da7 <mappages+0x67>
80106d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106d70:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106d77:	c1 ea 0a             	shr    $0xa,%edx
80106d7a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106d80:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d87:	85 c0                	test   %eax,%eax
80106d89:	74 75                	je     80106e00 <mappages+0xc0>
    if(*pte & PTE_P)
80106d8b:	f6 00 01             	testb  $0x1,(%eax)
80106d8e:	0f 85 86 00 00 00    	jne    80106e1a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106d94:	0b 75 0c             	or     0xc(%ebp),%esi
80106d97:	83 ce 01             	or     $0x1,%esi
80106d9a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d9c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106d9f:	74 6f                	je     80106e10 <mappages+0xd0>
    a += PGSIZE;
80106da1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106da7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106daa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106dad:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106db0:	89 d8                	mov    %ebx,%eax
80106db2:	c1 e8 16             	shr    $0x16,%eax
80106db5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106db8:	8b 07                	mov    (%edi),%eax
80106dba:	a8 01                	test   $0x1,%al
80106dbc:	75 b2                	jne    80106d70 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106dbe:	e8 bd b8 ff ff       	call   80102680 <kalloc>
80106dc3:	85 c0                	test   %eax,%eax
80106dc5:	74 39                	je     80106e00 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106dc7:	83 ec 04             	sub    $0x4,%esp
80106dca:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106dcd:	68 00 10 00 00       	push   $0x1000
80106dd2:	6a 00                	push   $0x0
80106dd4:	50                   	push   %eax
80106dd5:	e8 b6 d8 ff ff       	call   80104690 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106dda:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106ddd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106de0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106de6:	83 c8 07             	or     $0x7,%eax
80106de9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106deb:	89 d8                	mov    %ebx,%eax
80106ded:	c1 e8 0a             	shr    $0xa,%eax
80106df0:	25 fc 0f 00 00       	and    $0xffc,%eax
80106df5:	01 d0                	add    %edx,%eax
80106df7:	eb 92                	jmp    80106d8b <mappages+0x4b>
80106df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e08:	5b                   	pop    %ebx
80106e09:	5e                   	pop    %esi
80106e0a:	5f                   	pop    %edi
80106e0b:	5d                   	pop    %ebp
80106e0c:	c3                   	ret    
80106e0d:	8d 76 00             	lea    0x0(%esi),%esi
80106e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e13:	31 c0                	xor    %eax,%eax
}
80106e15:	5b                   	pop    %ebx
80106e16:	5e                   	pop    %esi
80106e17:	5f                   	pop    %edi
80106e18:	5d                   	pop    %ebp
80106e19:	c3                   	ret    
      panic("remap");
80106e1a:	83 ec 0c             	sub    $0xc,%esp
80106e1d:	68 b8 7f 10 80       	push   $0x80107fb8
80106e22:	e8 59 95 ff ff       	call   80100380 <panic>
80106e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e2e:	66 90                	xchg   %ax,%ax

80106e30 <seginit>:
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e36:	e8 45 cb ff ff       	call   80103980 <cpuid>
  pd[0] = size-1;
80106e3b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106e40:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106e46:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e4a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106e51:	ff 00 00 
80106e54:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106e5b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e5e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106e65:	ff 00 00 
80106e68:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106e6f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e72:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106e79:	ff 00 00 
80106e7c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106e83:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e86:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106e8d:	ff 00 00 
80106e90:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106e97:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106e9a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106e9f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ea3:	c1 e8 10             	shr    $0x10,%eax
80106ea6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106eaa:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ead:	0f 01 10             	lgdtl  (%eax)
}
80106eb0:	c9                   	leave  
80106eb1:	c3                   	ret    
80106eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ec0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ec0:	a1 44 68 11 80       	mov    0x80116844,%eax
80106ec5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106eca:	0f 22 d8             	mov    %eax,%cr3
}
80106ecd:	c3                   	ret    
80106ece:	66 90                	xchg   %ax,%ax

80106ed0 <switchuvm>:
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	57                   	push   %edi
80106ed4:	56                   	push   %esi
80106ed5:	53                   	push   %ebx
80106ed6:	83 ec 1c             	sub    $0x1c,%esp
80106ed9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106edc:	85 f6                	test   %esi,%esi
80106ede:	0f 84 cb 00 00 00    	je     80106faf <switchuvm+0xdf>
  if(p->kstack == 0)
80106ee4:	8b 46 08             	mov    0x8(%esi),%eax
80106ee7:	85 c0                	test   %eax,%eax
80106ee9:	0f 84 da 00 00 00    	je     80106fc9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106eef:	8b 46 04             	mov    0x4(%esi),%eax
80106ef2:	85 c0                	test   %eax,%eax
80106ef4:	0f 84 c2 00 00 00    	je     80106fbc <switchuvm+0xec>
  pushcli();
80106efa:	e8 81 d5 ff ff       	call   80104480 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106eff:	e8 1c ca ff ff       	call   80103920 <mycpu>
80106f04:	89 c3                	mov    %eax,%ebx
80106f06:	e8 15 ca ff ff       	call   80103920 <mycpu>
80106f0b:	89 c7                	mov    %eax,%edi
80106f0d:	e8 0e ca ff ff       	call   80103920 <mycpu>
80106f12:	83 c7 08             	add    $0x8,%edi
80106f15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f18:	e8 03 ca ff ff       	call   80103920 <mycpu>
80106f1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f20:	ba 67 00 00 00       	mov    $0x67,%edx
80106f25:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f2c:	83 c0 08             	add    $0x8,%eax
80106f2f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f36:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f3b:	83 c1 08             	add    $0x8,%ecx
80106f3e:	c1 e8 18             	shr    $0x18,%eax
80106f41:	c1 e9 10             	shr    $0x10,%ecx
80106f44:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106f4a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106f50:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f55:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f5c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106f61:	e8 ba c9 ff ff       	call   80103920 <mycpu>
80106f66:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f6d:	e8 ae c9 ff ff       	call   80103920 <mycpu>
80106f72:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f76:	8b 5e 08             	mov    0x8(%esi),%ebx
80106f79:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f7f:	e8 9c c9 ff ff       	call   80103920 <mycpu>
80106f84:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f87:	e8 94 c9 ff ff       	call   80103920 <mycpu>
80106f8c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106f90:	b8 28 00 00 00       	mov    $0x28,%eax
80106f95:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106f98:	8b 46 04             	mov    0x4(%esi),%eax
80106f9b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fa0:	0f 22 d8             	mov    %eax,%cr3
}
80106fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fa6:	5b                   	pop    %ebx
80106fa7:	5e                   	pop    %esi
80106fa8:	5f                   	pop    %edi
80106fa9:	5d                   	pop    %ebp
  popcli();
80106faa:	e9 21 d5 ff ff       	jmp    801044d0 <popcli>
    panic("switchuvm: no process");
80106faf:	83 ec 0c             	sub    $0xc,%esp
80106fb2:	68 be 7f 10 80       	push   $0x80107fbe
80106fb7:	e8 c4 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106fbc:	83 ec 0c             	sub    $0xc,%esp
80106fbf:	68 e9 7f 10 80       	push   $0x80107fe9
80106fc4:	e8 b7 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106fc9:	83 ec 0c             	sub    $0xc,%esp
80106fcc:	68 d4 7f 10 80       	push   $0x80107fd4
80106fd1:	e8 aa 93 ff ff       	call   80100380 <panic>
80106fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fdd:	8d 76 00             	lea    0x0(%esi),%esi

80106fe0 <inituvm>:
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	57                   	push   %edi
80106fe4:	56                   	push   %esi
80106fe5:	53                   	push   %ebx
80106fe6:	83 ec 1c             	sub    $0x1c,%esp
80106fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fec:	8b 75 10             	mov    0x10(%ebp),%esi
80106fef:	8b 7d 08             	mov    0x8(%ebp),%edi
80106ff2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106ff5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ffb:	77 4b                	ja     80107048 <inituvm+0x68>
  mem = kalloc();
80106ffd:	e8 7e b6 ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80107002:	83 ec 04             	sub    $0x4,%esp
80107005:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010700a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010700c:	6a 00                	push   $0x0
8010700e:	50                   	push   %eax
8010700f:	e8 7c d6 ff ff       	call   80104690 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107014:	58                   	pop    %eax
80107015:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010701b:	5a                   	pop    %edx
8010701c:	6a 06                	push   $0x6
8010701e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107023:	31 d2                	xor    %edx,%edx
80107025:	50                   	push   %eax
80107026:	89 f8                	mov    %edi,%eax
80107028:	e8 13 fd ff ff       	call   80106d40 <mappages>
  memmove(mem, init, sz);
8010702d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107030:	89 75 10             	mov    %esi,0x10(%ebp)
80107033:	83 c4 10             	add    $0x10,%esp
80107036:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107039:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010703c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010703f:	5b                   	pop    %ebx
80107040:	5e                   	pop    %esi
80107041:	5f                   	pop    %edi
80107042:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107043:	e9 e8 d6 ff ff       	jmp    80104730 <memmove>
    panic("inituvm: more than a page");
80107048:	83 ec 0c             	sub    $0xc,%esp
8010704b:	68 fd 7f 10 80       	push   $0x80107ffd
80107050:	e8 2b 93 ff ff       	call   80100380 <panic>
80107055:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010705c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107060 <loaduvm>:
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	57                   	push   %edi
80107064:	56                   	push   %esi
80107065:	53                   	push   %ebx
80107066:	83 ec 1c             	sub    $0x1c,%esp
80107069:	8b 45 0c             	mov    0xc(%ebp),%eax
8010706c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010706f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107074:	0f 85 bb 00 00 00    	jne    80107135 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010707a:	01 f0                	add    %esi,%eax
8010707c:	89 f3                	mov    %esi,%ebx
8010707e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107081:	8b 45 14             	mov    0x14(%ebp),%eax
80107084:	01 f0                	add    %esi,%eax
80107086:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107089:	85 f6                	test   %esi,%esi
8010708b:	0f 84 87 00 00 00    	je     80107118 <loaduvm+0xb8>
80107091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107098:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010709b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010709e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
801070a0:	89 c2                	mov    %eax,%edx
801070a2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801070a5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801070a8:	f6 c2 01             	test   $0x1,%dl
801070ab:	75 13                	jne    801070c0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801070ad:	83 ec 0c             	sub    $0xc,%esp
801070b0:	68 17 80 10 80       	push   $0x80108017
801070b5:	e8 c6 92 ff ff       	call   80100380 <panic>
801070ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801070c0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801070c9:	25 fc 0f 00 00       	and    $0xffc,%eax
801070ce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801070d5:	85 c0                	test   %eax,%eax
801070d7:	74 d4                	je     801070ad <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
801070d9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070db:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801070de:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801070e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801070e8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801070ee:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070f1:	29 d9                	sub    %ebx,%ecx
801070f3:	05 00 00 00 80       	add    $0x80000000,%eax
801070f8:	57                   	push   %edi
801070f9:	51                   	push   %ecx
801070fa:	50                   	push   %eax
801070fb:	ff 75 10             	push   0x10(%ebp)
801070fe:	e8 8d a9 ff ff       	call   80101a90 <readi>
80107103:	83 c4 10             	add    $0x10,%esp
80107106:	39 f8                	cmp    %edi,%eax
80107108:	75 1e                	jne    80107128 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010710a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107110:	89 f0                	mov    %esi,%eax
80107112:	29 d8                	sub    %ebx,%eax
80107114:	39 c6                	cmp    %eax,%esi
80107116:	77 80                	ja     80107098 <loaduvm+0x38>
}
80107118:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010711b:	31 c0                	xor    %eax,%eax
}
8010711d:	5b                   	pop    %ebx
8010711e:	5e                   	pop    %esi
8010711f:	5f                   	pop    %edi
80107120:	5d                   	pop    %ebp
80107121:	c3                   	ret    
80107122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107128:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010712b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107130:	5b                   	pop    %ebx
80107131:	5e                   	pop    %esi
80107132:	5f                   	pop    %edi
80107133:	5d                   	pop    %ebp
80107134:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107135:	83 ec 0c             	sub    $0xc,%esp
80107138:	68 b8 80 10 80       	push   $0x801080b8
8010713d:	e8 3e 92 ff ff       	call   80100380 <panic>
80107142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107150 <allocuvm>:
{
80107150:	55                   	push   %ebp
80107151:	89 e5                	mov    %esp,%ebp
80107153:	57                   	push   %edi
80107154:	56                   	push   %esi
80107155:	53                   	push   %ebx
80107156:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107159:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010715c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010715f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107162:	85 c0                	test   %eax,%eax
80107164:	0f 88 b6 00 00 00    	js     80107220 <allocuvm+0xd0>
  if(newsz < oldsz)
8010716a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010716d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107170:	0f 82 9a 00 00 00    	jb     80107210 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107176:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010717c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107182:	39 75 10             	cmp    %esi,0x10(%ebp)
80107185:	77 44                	ja     801071cb <allocuvm+0x7b>
80107187:	e9 87 00 00 00       	jmp    80107213 <allocuvm+0xc3>
8010718c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107190:	83 ec 04             	sub    $0x4,%esp
80107193:	68 00 10 00 00       	push   $0x1000
80107198:	6a 00                	push   $0x0
8010719a:	50                   	push   %eax
8010719b:	e8 f0 d4 ff ff       	call   80104690 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801071a0:	58                   	pop    %eax
801071a1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801071a7:	5a                   	pop    %edx
801071a8:	6a 06                	push   $0x6
801071aa:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071af:	89 f2                	mov    %esi,%edx
801071b1:	50                   	push   %eax
801071b2:	89 f8                	mov    %edi,%eax
801071b4:	e8 87 fb ff ff       	call   80106d40 <mappages>
801071b9:	83 c4 10             	add    $0x10,%esp
801071bc:	85 c0                	test   %eax,%eax
801071be:	78 78                	js     80107238 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801071c0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801071c6:	39 75 10             	cmp    %esi,0x10(%ebp)
801071c9:	76 48                	jbe    80107213 <allocuvm+0xc3>
    mem = kalloc();
801071cb:	e8 b0 b4 ff ff       	call   80102680 <kalloc>
801071d0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801071d2:	85 c0                	test   %eax,%eax
801071d4:	75 ba                	jne    80107190 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801071d6:	83 ec 0c             	sub    $0xc,%esp
801071d9:	68 35 80 10 80       	push   $0x80108035
801071de:	e8 bd 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801071e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801071e6:	83 c4 10             	add    $0x10,%esp
801071e9:	39 45 10             	cmp    %eax,0x10(%ebp)
801071ec:	74 32                	je     80107220 <allocuvm+0xd0>
801071ee:	8b 55 10             	mov    0x10(%ebp),%edx
801071f1:	89 c1                	mov    %eax,%ecx
801071f3:	89 f8                	mov    %edi,%eax
801071f5:	e8 96 fa ff ff       	call   80106c90 <deallocuvm.part.0>
      return 0;
801071fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107201:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107204:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107207:	5b                   	pop    %ebx
80107208:	5e                   	pop    %esi
80107209:	5f                   	pop    %edi
8010720a:	5d                   	pop    %ebp
8010720b:	c3                   	ret    
8010720c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107210:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107213:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107216:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107219:	5b                   	pop    %ebx
8010721a:	5e                   	pop    %esi
8010721b:	5f                   	pop    %edi
8010721c:	5d                   	pop    %ebp
8010721d:	c3                   	ret    
8010721e:	66 90                	xchg   %ax,%ax
    return 0;
80107220:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107227:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010722a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010722d:	5b                   	pop    %ebx
8010722e:	5e                   	pop    %esi
8010722f:	5f                   	pop    %edi
80107230:	5d                   	pop    %ebp
80107231:	c3                   	ret    
80107232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107238:	83 ec 0c             	sub    $0xc,%esp
8010723b:	68 4d 80 10 80       	push   $0x8010804d
80107240:	e8 5b 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107245:	8b 45 0c             	mov    0xc(%ebp),%eax
80107248:	83 c4 10             	add    $0x10,%esp
8010724b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010724e:	74 0c                	je     8010725c <allocuvm+0x10c>
80107250:	8b 55 10             	mov    0x10(%ebp),%edx
80107253:	89 c1                	mov    %eax,%ecx
80107255:	89 f8                	mov    %edi,%eax
80107257:	e8 34 fa ff ff       	call   80106c90 <deallocuvm.part.0>
      kfree(mem);
8010725c:	83 ec 0c             	sub    $0xc,%esp
8010725f:	53                   	push   %ebx
80107260:	e8 5b b2 ff ff       	call   801024c0 <kfree>
      return 0;
80107265:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010726c:	83 c4 10             	add    $0x10,%esp
}
8010726f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107272:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107275:	5b                   	pop    %ebx
80107276:	5e                   	pop    %esi
80107277:	5f                   	pop    %edi
80107278:	5d                   	pop    %ebp
80107279:	c3                   	ret    
8010727a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107280 <deallocuvm>:
{
80107280:	55                   	push   %ebp
80107281:	89 e5                	mov    %esp,%ebp
80107283:	8b 55 0c             	mov    0xc(%ebp),%edx
80107286:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107289:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010728c:	39 d1                	cmp    %edx,%ecx
8010728e:	73 10                	jae    801072a0 <deallocuvm+0x20>
}
80107290:	5d                   	pop    %ebp
80107291:	e9 fa f9 ff ff       	jmp    80106c90 <deallocuvm.part.0>
80107296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010729d:	8d 76 00             	lea    0x0(%esi),%esi
801072a0:	89 d0                	mov    %edx,%eax
801072a2:	5d                   	pop    %ebp
801072a3:	c3                   	ret    
801072a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072af:	90                   	nop

801072b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	57                   	push   %edi
801072b4:	56                   	push   %esi
801072b5:	53                   	push   %ebx
801072b6:	83 ec 0c             	sub    $0xc,%esp
801072b9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801072bc:	85 f6                	test   %esi,%esi
801072be:	74 59                	je     80107319 <freevm+0x69>
  if(newsz >= oldsz)
801072c0:	31 c9                	xor    %ecx,%ecx
801072c2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801072c7:	89 f0                	mov    %esi,%eax
801072c9:	89 f3                	mov    %esi,%ebx
801072cb:	e8 c0 f9 ff ff       	call   80106c90 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072d0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801072d6:	eb 0f                	jmp    801072e7 <freevm+0x37>
801072d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072df:	90                   	nop
801072e0:	83 c3 04             	add    $0x4,%ebx
801072e3:	39 df                	cmp    %ebx,%edi
801072e5:	74 23                	je     8010730a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801072e7:	8b 03                	mov    (%ebx),%eax
801072e9:	a8 01                	test   $0x1,%al
801072eb:	74 f3                	je     801072e0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801072f2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801072f5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072f8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801072fd:	50                   	push   %eax
801072fe:	e8 bd b1 ff ff       	call   801024c0 <kfree>
80107303:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107306:	39 df                	cmp    %ebx,%edi
80107308:	75 dd                	jne    801072e7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010730a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010730d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107310:	5b                   	pop    %ebx
80107311:	5e                   	pop    %esi
80107312:	5f                   	pop    %edi
80107313:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107314:	e9 a7 b1 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107319:	83 ec 0c             	sub    $0xc,%esp
8010731c:	68 69 80 10 80       	push   $0x80108069
80107321:	e8 5a 90 ff ff       	call   80100380 <panic>
80107326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010732d:	8d 76 00             	lea    0x0(%esi),%esi

80107330 <setupkvm>:
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	56                   	push   %esi
80107334:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107335:	e8 46 b3 ff ff       	call   80102680 <kalloc>
8010733a:	89 c6                	mov    %eax,%esi
8010733c:	85 c0                	test   %eax,%eax
8010733e:	74 42                	je     80107382 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107340:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107343:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107348:	68 00 10 00 00       	push   $0x1000
8010734d:	6a 00                	push   $0x0
8010734f:	50                   	push   %eax
80107350:	e8 3b d3 ff ff       	call   80104690 <memset>
80107355:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107358:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010735b:	83 ec 08             	sub    $0x8,%esp
8010735e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107361:	ff 73 0c             	push   0xc(%ebx)
80107364:	8b 13                	mov    (%ebx),%edx
80107366:	50                   	push   %eax
80107367:	29 c1                	sub    %eax,%ecx
80107369:	89 f0                	mov    %esi,%eax
8010736b:	e8 d0 f9 ff ff       	call   80106d40 <mappages>
80107370:	83 c4 10             	add    $0x10,%esp
80107373:	85 c0                	test   %eax,%eax
80107375:	78 19                	js     80107390 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107377:	83 c3 10             	add    $0x10,%ebx
8010737a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107380:	75 d6                	jne    80107358 <setupkvm+0x28>
}
80107382:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107385:	89 f0                	mov    %esi,%eax
80107387:	5b                   	pop    %ebx
80107388:	5e                   	pop    %esi
80107389:	5d                   	pop    %ebp
8010738a:	c3                   	ret    
8010738b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010738f:	90                   	nop
      freevm(pgdir);
80107390:	83 ec 0c             	sub    $0xc,%esp
80107393:	56                   	push   %esi
      return 0;
80107394:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107396:	e8 15 ff ff ff       	call   801072b0 <freevm>
      return 0;
8010739b:	83 c4 10             	add    $0x10,%esp
}
8010739e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801073a1:	89 f0                	mov    %esi,%eax
801073a3:	5b                   	pop    %ebx
801073a4:	5e                   	pop    %esi
801073a5:	5d                   	pop    %ebp
801073a6:	c3                   	ret    
801073a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ae:	66 90                	xchg   %ax,%ax

801073b0 <kvmalloc>:
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801073b6:	e8 75 ff ff ff       	call   80107330 <setupkvm>
801073bb:	a3 44 68 11 80       	mov    %eax,0x80116844
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073c0:	05 00 00 00 80       	add    $0x80000000,%eax
801073c5:	0f 22 d8             	mov    %eax,%cr3
}
801073c8:	c9                   	leave  
801073c9:	c3                   	ret    
801073ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073d0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801073d0:	55                   	push   %ebp
801073d1:	89 e5                	mov    %esp,%ebp
801073d3:	83 ec 08             	sub    $0x8,%esp
801073d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801073d9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801073dc:	89 c1                	mov    %eax,%ecx
801073de:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801073e1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801073e4:	f6 c2 01             	test   $0x1,%dl
801073e7:	75 17                	jne    80107400 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801073e9:	83 ec 0c             	sub    $0xc,%esp
801073ec:	68 7a 80 10 80       	push   $0x8010807a
801073f1:	e8 8a 8f ff ff       	call   80100380 <panic>
801073f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073fd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107400:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107403:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107409:	25 fc 0f 00 00       	and    $0xffc,%eax
8010740e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107415:	85 c0                	test   %eax,%eax
80107417:	74 d0                	je     801073e9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107419:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010741c:	c9                   	leave  
8010741d:	c3                   	ret    
8010741e:	66 90                	xchg   %ax,%ax

80107420 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	57                   	push   %edi
80107424:	56                   	push   %esi
80107425:	53                   	push   %ebx
80107426:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107429:	e8 02 ff ff ff       	call   80107330 <setupkvm>
8010742e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107431:	85 c0                	test   %eax,%eax
80107433:	0f 84 bd 00 00 00    	je     801074f6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107439:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010743c:	85 c9                	test   %ecx,%ecx
8010743e:	0f 84 b2 00 00 00    	je     801074f6 <copyuvm+0xd6>
80107444:	31 f6                	xor    %esi,%esi
80107446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010744d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107450:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107453:	89 f0                	mov    %esi,%eax
80107455:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107458:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010745b:	a8 01                	test   $0x1,%al
8010745d:	75 11                	jne    80107470 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010745f:	83 ec 0c             	sub    $0xc,%esp
80107462:	68 84 80 10 80       	push   $0x80108084
80107467:	e8 14 8f ff ff       	call   80100380 <panic>
8010746c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107470:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107472:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107477:	c1 ea 0a             	shr    $0xa,%edx
8010747a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107480:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107487:	85 c0                	test   %eax,%eax
80107489:	74 d4                	je     8010745f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010748b:	8b 00                	mov    (%eax),%eax
8010748d:	a8 01                	test   $0x1,%al
8010748f:	0f 84 9f 00 00 00    	je     80107534 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107495:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107497:	25 ff 0f 00 00       	and    $0xfff,%eax
8010749c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010749f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801074a5:	e8 d6 b1 ff ff       	call   80102680 <kalloc>
801074aa:	89 c3                	mov    %eax,%ebx
801074ac:	85 c0                	test   %eax,%eax
801074ae:	74 64                	je     80107514 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801074b0:	83 ec 04             	sub    $0x4,%esp
801074b3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801074b9:	68 00 10 00 00       	push   $0x1000
801074be:	57                   	push   %edi
801074bf:	50                   	push   %eax
801074c0:	e8 6b d2 ff ff       	call   80104730 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801074c5:	58                   	pop    %eax
801074c6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074cc:	5a                   	pop    %edx
801074cd:	ff 75 e4             	push   -0x1c(%ebp)
801074d0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074d5:	89 f2                	mov    %esi,%edx
801074d7:	50                   	push   %eax
801074d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074db:	e8 60 f8 ff ff       	call   80106d40 <mappages>
801074e0:	83 c4 10             	add    $0x10,%esp
801074e3:	85 c0                	test   %eax,%eax
801074e5:	78 21                	js     80107508 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801074e7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801074ed:	39 75 0c             	cmp    %esi,0xc(%ebp)
801074f0:	0f 87 5a ff ff ff    	ja     80107450 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801074f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074fc:	5b                   	pop    %ebx
801074fd:	5e                   	pop    %esi
801074fe:	5f                   	pop    %edi
801074ff:	5d                   	pop    %ebp
80107500:	c3                   	ret    
80107501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107508:	83 ec 0c             	sub    $0xc,%esp
8010750b:	53                   	push   %ebx
8010750c:	e8 af af ff ff       	call   801024c0 <kfree>
      goto bad;
80107511:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107514:	83 ec 0c             	sub    $0xc,%esp
80107517:	ff 75 e0             	push   -0x20(%ebp)
8010751a:	e8 91 fd ff ff       	call   801072b0 <freevm>
  return 0;
8010751f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107526:	83 c4 10             	add    $0x10,%esp
}
80107529:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010752c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010752f:	5b                   	pop    %ebx
80107530:	5e                   	pop    %esi
80107531:	5f                   	pop    %edi
80107532:	5d                   	pop    %ebp
80107533:	c3                   	ret    
      panic("copyuvm: page not present");
80107534:	83 ec 0c             	sub    $0xc,%esp
80107537:	68 9e 80 10 80       	push   $0x8010809e
8010753c:	e8 3f 8e ff ff       	call   80100380 <panic>
80107541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010754f:	90                   	nop

80107550 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107556:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107559:	89 c1                	mov    %eax,%ecx
8010755b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010755e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107561:	f6 c2 01             	test   $0x1,%dl
80107564:	0f 84 00 01 00 00    	je     8010766a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010756a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010756d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107573:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107574:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107579:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107580:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107582:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107587:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010758a:	05 00 00 00 80       	add    $0x80000000,%eax
8010758f:	83 fa 05             	cmp    $0x5,%edx
80107592:	ba 00 00 00 00       	mov    $0x0,%edx
80107597:	0f 45 c2             	cmovne %edx,%eax
}
8010759a:	c3                   	ret    
8010759b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010759f:	90                   	nop

801075a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801075a0:	55                   	push   %ebp
801075a1:	89 e5                	mov    %esp,%ebp
801075a3:	57                   	push   %edi
801075a4:	56                   	push   %esi
801075a5:	53                   	push   %ebx
801075a6:	83 ec 0c             	sub    $0xc,%esp
801075a9:	8b 75 14             	mov    0x14(%ebp),%esi
801075ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801075af:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801075b2:	85 f6                	test   %esi,%esi
801075b4:	75 51                	jne    80107607 <copyout+0x67>
801075b6:	e9 a5 00 00 00       	jmp    80107660 <copyout+0xc0>
801075bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075bf:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801075c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801075c6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801075cc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801075d2:	74 75                	je     80107649 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801075d4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801075d6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801075d9:	29 c3                	sub    %eax,%ebx
801075db:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801075e1:	39 f3                	cmp    %esi,%ebx
801075e3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801075e6:	29 f8                	sub    %edi,%eax
801075e8:	83 ec 04             	sub    $0x4,%esp
801075eb:	01 c1                	add    %eax,%ecx
801075ed:	53                   	push   %ebx
801075ee:	52                   	push   %edx
801075ef:	51                   	push   %ecx
801075f0:	e8 3b d1 ff ff       	call   80104730 <memmove>
    len -= n;
    buf += n;
801075f5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801075f8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801075fe:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107601:	01 da                	add    %ebx,%edx
  while(len > 0){
80107603:	29 de                	sub    %ebx,%esi
80107605:	74 59                	je     80107660 <copyout+0xc0>
  if(*pde & PTE_P){
80107607:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010760a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010760c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010760e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107611:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107617:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010761a:	f6 c1 01             	test   $0x1,%cl
8010761d:	0f 84 4e 00 00 00    	je     80107671 <copyout.cold>
  return &pgtab[PTX(va)];
80107623:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107625:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010762b:	c1 eb 0c             	shr    $0xc,%ebx
8010762e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107634:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010763b:	89 d9                	mov    %ebx,%ecx
8010763d:	83 e1 05             	and    $0x5,%ecx
80107640:	83 f9 05             	cmp    $0x5,%ecx
80107643:	0f 84 77 ff ff ff    	je     801075c0 <copyout+0x20>
  }
  return 0;
}
80107649:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010764c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107651:	5b                   	pop    %ebx
80107652:	5e                   	pop    %esi
80107653:	5f                   	pop    %edi
80107654:	5d                   	pop    %ebp
80107655:	c3                   	ret    
80107656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010765d:	8d 76 00             	lea    0x0(%esi),%esi
80107660:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107663:	31 c0                	xor    %eax,%eax
}
80107665:	5b                   	pop    %ebx
80107666:	5e                   	pop    %esi
80107667:	5f                   	pop    %edi
80107668:	5d                   	pop    %ebp
80107669:	c3                   	ret    

8010766a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010766a:	a1 00 00 00 00       	mov    0x0,%eax
8010766f:	0f 0b                	ud2    

80107671 <copyout.cold>:
80107671:	a1 00 00 00 00       	mov    0x0,%eax
80107676:	0f 0b                	ud2    
