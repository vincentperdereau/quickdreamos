CLS

INPUT "dossector=", dossector
psector = FIX(1 + (dossector MOD 18))
phead = FIX((dossector / 18) MOD 2)
ptrack = FIX(dossector / (18 * 2))
dsector = FIX((psector - 1) + (phead * 18) + (ptrack * 18 * 2))
PRINT "sector=", psector
PRINT "head=", phead
PRINT "track=", ptrack
PRINT "dossector=", dsector
SYSTEM
10 :
INPUT "cluster=", cluster
sector = FIX((cluster / (512 * 8)))
octet = FIX((cluster / 8) MOD 512)
bit = FIX(1 + (cluster MOD 8))
PRINT "sector=", sector
PRINT "octet=", octet
PRINT "bit=", bit
pcluster = (bit - 1) + (octet * 8) + (sector * 8 * 512)
PRINT "pcluster=", pcluster

